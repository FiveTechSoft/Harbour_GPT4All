# Harbour_GPT4All

GPT4All is the most advanced free and open source AI engine actually: 

https://github.com/nomic-ai/gpt4all

You may check if there is a more recent gpt4all-lora-quantized-win64.exe here:

https://github.com/nomic-ai/gpt4all/blob/main/chat/gpt4all-lora-quantized-win64.exe

You have to download the BIN (data) file from here:

https://the-eye.eu/public/AI/models/nomic-ai/gpt4all/gpt4all-lora-quantized.bin

first of all please download the above files and run the EXE to check that it works on your computer. 

If the PC CPU does not have AVX2 support, gpt4all-lora-quantized-win64.exe will not work. gpt4all.prg checks
if you have AVX2 support.

It seems that GPT4ALL forces AVX2 set of CPU instructions even if they are not supported by the CPU. To fix this you need to build GPT4ALL by yourself from this repo https://github.com/zanussbaum/gpt4all.cpp. Prior to building change the lines 86, 87, 88 in the file CMakeLists.txt from AVX2 to AVX.

chatGPT and similars have taken the computing world by storm. Actually there are two ways to have that power from your apps:

1. The commercial way (OpenAI, etc)
2. The free and open source way (llama.cpp, GPT4All)

CLASS TGPT4All() basically invokes gpt4all-lora-quantized-win64.exe as a process, thanks to Harbour's great processes functions,
and uses a piped in/out connection to it, so this means that we can use the most modern free AI from our Harbour apps.

It seems as there is a max 2048 tokens limit for the input (we have not checked it yet), and you can use data from your DBFs,
SQL, emails, etc. and provide such info the free AI, running locally, without having to use internet and free of use with no cost.

In case that you modify the source code for improving it, testing, etc. if your computer turns very slow, do this from a cmd window:

taskkill /f /im gpt4all-lora-quantized-win64.exe

Run gpt4all-lora-quantized-win64.exe -h to see all the possible options:

```
usage: gpt4all-lora-quantized-win64.exe [options]

options:
  -h, --help            show this help message and exit
  -i, --interactive     run in interactive mode
  --interactive-start   run in interactive mode and poll user input at startup
  -r PROMPT, --reverse-prompt PROMPT
                        in interactive mode, poll user input upon seeing PROMPT
  --color               colorise output to distinguish prompt and user input from generations
  -s SEED, --seed SEED  RNG seed (default: -1)
  -t N, --threads N     number of threads to use during computation (default: 4)
  -p PROMPT, --prompt PROMPT
                        prompt to start generation with (default: random)
  -f FNAME, --file FNAME
                        prompt file to start generation.
  -n N, --n_predict N   number of tokens to predict (default: 128)
  --top_k N             top-k sampling (default: 40)
  --top_p N             top-p sampling (default: 0.9)
  --repeat_last_n N     last n tokens to consider for penalize (default: 64)
  --repeat_penalty N    penalize repeat sequence of tokens (default: 1.3)
  -c N, --ctx_size N    size of the prompt context (default: 2048)
  --temp N              temperature (default: 0.1)
  -b N, --batch_size N  batch size for prompt processing (default: 8)
  -m FNAME, --model FNAME
                        model path (default: gpt4all-lora-quantized.bin)
```
