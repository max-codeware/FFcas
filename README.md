## Description:
This is a very simple and basic cas which allows to create symbolic functions, and to derivate them.

## Status:
Testing

## How to use:
Download the .zip file from https://github.com/max-codeware/FFcas, unpack it and open the terminal from 
the folder FFcas is saved in.
Then, type:
```sh
$ cd FFtests
$ ./FF.rb
```
and a simple interactive cas will start.

Up to now it performs only operations between symbolic functions and symbolic differentials.

If a variable begins with `#`, it will be interpreted as a variable to store data,
while all the rest as a math parameter.

To ask for a sybolic differential the sintax is:
```
diff(_variable_)(_function_)
```
Example:
```
diff(x)(log(x))
#=> 1/x
```

The supported math functions are:
* log()
* exp()
* tan()
* atan()
* sin()
* asin()
* cos()
* acos()
* sqrt()

The supported constants are:
* PI
* e
* INF (infinity)
* N_INF (negative infinity)


it is also posible to write a file with the same rules, and the type `./FF.rb /path/to/the/file.ff`
anf FFcas will scan your file. Everything that's not an assignment will be printed out.

## Contributing:
Bug reports and pull requests are absolutely welcomed at https://github.com/max-codeware/FFcas, or email me at max.codeware@gmail.com





