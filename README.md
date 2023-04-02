# Harbour_GPT4All

You have to download the BIN (data) file from here:

https://the-eye.eu/public/AI/models/nomic-ai/gpt4all/gpt4all-lora-quantized.bin

chatGPT and similars have taken the computing world by storm. Actually there are two ways to have that power from your apps:

1. The commercial way (OpenAI, etc)
2. The free and open source way (llama.cpp, GPT4All)

CLASS TGPT4All() basically invokes gpt4all-lora-quantized-win64.exe as a process, thanks Harbour's great processes functions,
and uses a piped in/out connection to it, so this means that we can use the most modern free AI from our apps.

It seems as there is a max 2048 tokens limit for the input (we have nt checked it yet), and you can use data from your DBFs,
SQL, emails, etc. and provide such info the free AI, running locally, without having to use internet and free os use.

