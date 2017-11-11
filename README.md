<h1 align="center">Recolor</h1>

<p align="center">A Ruby library to convert between color models.</p>

## Disclaimer

This library was developed for personal use. As a development student I wanted to learn Ruby and also try to implement [Alexei Boronine's](#credits) [HSLuv](http://www.hsluv.org) for personal use. **Use at your own discretion**.

## Table of Contents

- [Usage](#usage)
- [Supported Color Models](#supported-color-models)
- [Extending](#extending)
  - [Adding Color Models](#adding-color-models)
  - [Formatting Output](#formatting-output)
- [Credits](#credits)
- [License](#license)

## Usage

1. Clone or download the repository, build and install the gem:

    ```shell
    $ git clone https://github.com/albertobeloni/ruby-recolor.git
    $ cd ruby-recolor
    $ gem build recolor.gemspec
    $ gem install recolor-0.1.0.gem
    ```

2. Require and use it in your project:

    ```ruby
    require "recolor"

    recolor = Recolor::Recolor.new
    color = recolor.color(:hexadecimal, ["ff", "ff", "ff"])

    puts color.to(:rgb) # [1, 1, 1]
    puts color.to(:xyz) # [0.95045592705165, 0.999999999999993, 1.089057750759871]
    puts color.to(:luv) # [99.99999999999973, 4.979350265443814e-12, 1.8041124150158747e-12]
    puts color.to(:lch) # [99.99999999999973, 5.296107124293257e-12, 19.916405993809086]
    puts color.to(:hsluv) # [19.916405993809086, 0.0, 100]
    puts color.to(:hpluv) # [19.916405993809086, 0.0, 100]
    ```

## Supported Color Models

- [RGB](https://en.wikipedia.org/wiki/RGB_color_model): Standard RGB.
- [XYZ](https://en.wikipedia.org/wiki/CIE_1931_color_space): One of the first mathematically defined color spaces.
- [CIELUV](https://en.wikipedia.org/wiki/CIELUV): A color space made for perceptual uniformity.
- [CIELCH](https://en.wikipedia.org/wiki/CIELUV): A cylindrical representation of CIELUV.
- [HSLuv](http://www.hsluv.org): A color space designed for perceptual uniformity based on human experiments.
- [HPLuv](http://www.hsluv.org): Based on HSLuv but without distorting the chroma.
- Hexadecimal: A string representation of RGB.

## Extending

### Adding Color Models

1. Create a new model extending the ```Recolor::Models::Model``` class. The class must have at least one method to convert to another model — named after the corresponding model — which must return a color tuple in an appropriate format:

    ```ruby
    module Recolor
      module Models
        class ABC < Model
          def hexadecimal(tuple)
            tuple = tuple.reverse
          end
        end
      end
    end
    ```

2. If you want to convert *to* the new model, extend one of the default models and implement a conversion method to the new model:

    ```ruby
    module Recolor
      module Models
        class Hexadecimal < Model
          def abc(tuple)
            tuple = tuple.reverse
          end
        end
      end
    end
    ```

3. Register and use the new model:

    ```ruby
    recolor.models[:abc] = Recolor::Models::ABC.new
    recolor.converter.models[:abc] = recolor.models[:abc]

    color = recolor.color(:abc, ["00", "00", "ff"])
    puts color.to(:hexadecimal) # ["ff", "00", "00"]
    ```

    If you implemented a two way conversion to at least one default model, you can convert to and from any other default models:

    ```ruby
    color = recolor.color(:abc, ["00", "00", "ff"])
    puts color.to(:hexadecimal) # ["ff", "00", "00"]

    color = recolor.color(:hexadecimal, ["ff", "00", "00"])
    puts color.to(:abc) # ["00", "00", "ff"]

    color = recolor.color(:rgb, [1, 0, 0])
    puts color.to(:abc) # ["00", "00", "ff"]
    ```

### Formatting Output

By default the ```Recolor.color``` method returns a cloned Recolor instance. This allows the use of the same color definition to convert to more than one model, like so:

```ruby
color = recolor.color(:rgb, [1, 0, 0])
color = color.to(:xyz)
color = color.to(:luv)
color = color.to(:luv).to(:rgb).to(:lch) # You get the idea…
p color # #<Recolor::Recolor:0x000…
```

To use the color value, you can call the ```Recolor.tuple``` method, which returns the tuple representation of the color on the current model.


```ruby
color = recolor.color(:rgb, [1, 0, 0])
color = color.to(:hexadecimal)
p color.tuple # ["ff", "0", "0"]
```

Another way to use the color is to print it, which converts the tuple into string…

```ruby
color = recolor.color(:rgb, [1, 0, 0])
puts color # "[1, 0, 0]"
```

**It is possible to format the output in two ways:**

1. Using the ```Recolor.format``` method to format the current color:

    ```ruby
    color = recolor.color(:rgb, [1, 0, 0])
    color = color.to(:hexadecimal).format do |tuple|
      "##{tuple.join}"
    end
    puts color # #ff0000
    ```

2. Setting the ```Model.format``` variable to a lambda function, which will be used to format all output from this model:

    ```ruby
    recolor.models[:hexadecimal].format = lambda do |tuple|
      "##{tuple.join}"
    end
    color = recolor.color(:rgb, [1, 0, 0]).to(:hexadecimal)
    puts color # #ff0000
    ```

## Credits

- [Alexei Boronine](https://github.com/boronine) — HSLuv and HPLuv Color Space idea and implementation.

## License

This project is licensed under the MIT License — see the [LICENSE.md](LICENSE.md) file for details
