# st-murmurhash
Murmurhash implementation for the IEC 61131-3 ST language.

In short I needed to implement collection element in CoDeSys and that obviously needs an hash algorithm. As the data 
type I am using is complex, I needed some sensible hashing algorithm, which is not required to be crypto solid.

Ended up on the MurmurHash (thank you OpenAI for recommendation) and after fixing some weird stuff that is ST specific
got it working.

### Weird stuff
- ST case does not fall through, so implementation is needed for each of the leftover byte scenarios
- Because it does not fall through, also to avoid duplication of the code IF statement was needed in case lenght / 4 is not exact
- For method HAS to use INT, because otherwise the number of blocks = 0 does not work
