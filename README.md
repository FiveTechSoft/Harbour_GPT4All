# Harbour_GPT4All

GPT4All is the most advanced free and open source AI engine actually: 

https://github.com/nomic-ai/gpt4all

You may check if there is a more recent gpt4all-lora-quantized-win64.exe here:

https://github.com/nomic-ai/gpt4all/blob/main/chat/gpt4all-lora-quantized-win64.exe

You have to download the BIN (data) file from here:

https://the-eye.eu/public/AI/models/nomic-ai/gpt4all/gpt4all-lora-quantized.bin

first of all please download the above files and run the EXE to check that it works on your computer. 

If the PC CPU does not have AVX2 support, gpt4all-lora-quantized-win64.exe will not work. To check if your CPU supports them use this tool HWiNFO: 

https://www.hwinfo.com/download/

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
