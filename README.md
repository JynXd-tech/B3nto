# B3nto Payload

Payload for reload newiBoot using iBoot exploit (De Rebus Antiquis etc..)  

## build
- rdsk_maker  
```
gcc rdsk_maker.c -o rdsk_maker
```

- payload  
```
cd iPhone5,2/11D257/asm/
./build.sh
```

## gen  
```
./rdsk_maker iPhone5,2/11D257/exploit_generic iPhone5,2/11D257/exploit iPhone5,2/11D257/asm/iboot_p1.bin iPhone5,2/11D257/asm/payload.bin
```

## thanks  
basic payload, iBoot exploit: xerub  

license: GPLv3
