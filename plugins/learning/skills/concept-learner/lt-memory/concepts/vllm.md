# vllm

## Summary
vllm is a high-throughput LLM inference serving engine. Its core innovation is PagedAttention, which manages the KV cache in small non-contiguous memory pages (inspired by OS virtual memory) to eliminate fragmentation and dramatically increase the number of concurrent requests a single GPU can serve. Combined with continuous batching, it keeps GPU utilization near 100% under load.

## Key Points
- **KV Cache** is the bottleneck: stores Key/Value vectors for all prior tokens; grows linearly with sequence length and can consume gigabytes per request
- **PagedAttention** replaces fixed pre-allocated memory blocks with dynamic pages (e.g. 16 tokens each); pages are non-contiguous and can be shared across requests
- **Continuous batching** reshuffles the active batch after every decode step — finished requests are immediately replaced by waiting ones, eliminating idle GPU time
- **Prefix caching** reuses KV pages for shared prompt prefixes (e.g. system prompts); all requests pointing to the same prefix share physical pages without recomputation
- **Preemption/swapping**: under memory pressure, vllm can evict in-flight request pages to CPU RAM and resume them later
- vllm exposes an OpenAI-compatible HTTP API — it is a server, not a library function

## Architecture (V0)

Five layers, top to bottom:

| Layer | Components | Role |
|---|---|---|
| Client Interface | `AsyncLLMEngine`, `LLM` | Online serving (async HTTP) vs offline batch inference |
| Engine | `LLMEngine` | Central coordinator; owns request queue, drives the decode loop via `step()` |
| Scheduler | `Scheduler` | Continuous batching logic; manages block tables; decides running / preempted / waiting per step |
| Execution | `ModelExecutor` → `Worker` → `ModelRunner` | Orchestrates GPUs; one Worker per GPU; ModelRunner does the actual forward pass |
| Memory Management | KV Cache + PagedAttention kernel | Physical VRAM pool; custom CUDA kernel reads non-contiguous pages via block table |

**Key insight:** The Scheduler only manages *metadata* (block tables, queues) — it never touches the model. Physical VRAM lives in the Worker. This separation enables preemption/swapping without the model code knowing about it.

**Two inference modes:**

| | Offline (`LLM` class) | Online (`AsyncLLMEngine`) |
|---|---|---|
| Use case | Batch processing, scripts, no real-time needs | Chatbots, APIs, concurrent users |
| Style | Synchronous | Asynchronous |
| Server | No separate server | FastAPI-based HTTP server |
| Multi-turn | Not designed for it | Yes (streaming) |

**`LLMEngine` responsibilities:**
1. Process input requests (prefill)
2. Manage scheduling
3. Coordinate model execution
4. Handle output processing

**Launching online server:**
```bash
# Module-based
python -m vllm.entrypoints.openai.api_server --model meta-llama/Meta-Llama-3-8B

# CLI shorthand
vllm serve meta-llama/Meta-Llama-3-8B
```

**Calling it (OpenAI-compatible REST):**
```bash
curl http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "meta-llama/Meta-Llama-3-8B", "prompt": "San Francisco is a", "max_tokens": 7}'
```

## User's Prior Knowledge
- Strong on transformers/LLMs conceptually (training, attention, embeddings)
- No prior exposure to LLM serving or inference infrastructure
- Data scientist background

## Struggled With
- Nothing major; user grasped PagedAttention and continuous batching quickly and correctly

## Feature Reference

### Memory Management
| Feature | What it does |
|---|---|
| **PagedAttention** | Non-contiguous KV cache blocks; enables sharing across requests |
| **KV Cache Offloading** | Moves KV cache GPU → CPU when not immediately needed |
| **Prefix Caching** | Reuses KV pages for shared prompt prefixes automatically |
| **Chunked Prefill** | Breaks long inputs into segments; starts generating before full input is processed; ~30% TTFT reduction |
| **FP8 KV Cache Compression** | Quantizes cache values to reduce VRAM footprint |

### Scheduling & Batching
| Feature | What it does |
|---|---|
| **Continuous Batching** | New requests join as others finish; maintains GPU utilization |
| **Disaggregated Prefill** | Separates prefill and decode onto different GPU nodes; removes contention; useful for multimodal |
| **Multi-Step Scheduling** | Schedules once, runs model N consecutive steps; reduces CPU-GPU sync overhead |
| **Multi-Processing API Server** | API server and LLM engine in separate Python processes; avoids GIL contention |

### Generation Optimization
| Feature | What it does |
|---|---|
| **Speculative Decoding** | Small draft model guesses N tokens ahead; large model verifies in one batch; up to 1.5x speedup |
| **Flash Attention** | IO-aware CUDA kernel; keeps data on-chip (SRAM) during attention; best for long inputs + large batches |
| **FlashInfer** | Fuses ops, continuous batching, prefetching; handles heterogeneous KV cache via block-sparse format |

### Distributed Inference
| Strategy | How it splits | Notes |
|---|---|---|
| **Tensor Parallelism** | Weight matrices split across GPUs | Needs NVLink/InfiniBand; best latency |
| **Pipeline Parallelism** | Model layers split across GPUs | Lower communication overhead; latency concerns |
| **Data Parallelism** | Full model replicated; each GPU gets data subset | Best for throughput scaling |

### Key Metrics
- **TTFT** (Time To First Token): ~30% reduction via chunked prefill
- **ITL** (Inter-Token Latency): up to 1.4x improvement via batching
- **Throughput**: speculative decoding up to 1.5x speedup

### Configuration
`VllmConfig` class controls: model specs, resource allocation, inference params, cache settings, parallel execution, scheduling behavior, speculative decoding.

## Connected Concepts
- Speculative decoding (draft model predicts ahead, main model verifies in parallel — reduces latency)
- Quantization: AWQ, GPTQ, FP8 (reduces weight size → more pages fit in VRAM)
- Tensor parallelism vs pipeline parallelism (multi-GPU model sharding)
- KV cache in transformer attention (Q/K/V vectors)
- Flash Attention / FlashInfer (attention kernel optimizations)
- Disaggregated prefill (relevant for multimodal LLM serving)
