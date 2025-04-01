
## `04/01/2025`

### Lua GUI

I tried writing a logical GUI layout system, similar to a DOM. I have it working well enough and everything is generic.

However, it is __very__ inefficient, and there are issues with padding and setting width/height.
 
In hindsight, I think hard-coding the graphics for any menus I have is preferable to managing this GUI layout setup. At least until I actually _need_ a complex, generic GUI; at which point, it would probably be better to reach for an existing library.

### Javascript (?)

I added a vanilla `vite` setup so I could check my Lua GUI against different layout cases in actual HTML. This made me consider, "should I just write everything in JS in the browser?"

I would still like to see what Love2d could do, and I would like to stay away from JS for this project if I can. 

In fact, I think if love2d ends up being slow or I get annoyed with LuaJIT, I'd probably reach for `libgdx` w/ Java.

## `03/25/2025`

I started stubbing some things out in javascript, but I don't think that's a good target on the whole, unless I want to render an html canvas. For now I'll stick with it because it's what's in my head; other options:

* love2d (lua)
  * Pros:
    * easy to run
    * lua is easy to prototype in
    * supposedly portable if I want to share it
  * Cons:
    * lua seems like it gets hard to manage at larger scales
* Go
  * I forgot the names of the frameworks, but there are several easy cli->2d rendering libs
  * Pros:
    * reasonably fast
    * compact memory (structs)
  * Cons:
    * Go

    

