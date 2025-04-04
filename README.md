### flat assembler is an interpreter that outputs assembly code

#### more information: https://flatassembler.net/docs.php?article=ufasm

Information about file: `readelf -e ./website` (for example entry point address for debugging)

### In this project a socket bound to a webserver is created where a message via HTTP gets displayed

You'll need fasm: https://archlinux.org/packages/extra/x86_64/fasm/

Create an executable with `fasm website.asm` and run it with `./website` then go to `localhost:6969` in your browser
