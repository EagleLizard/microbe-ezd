import { Point } from '../geom/point';

/*
Biome. Where organism(s) live, generally.
  I"m just making a prototype, so I'm setting some assumptions
  upfront to try and prevent scope from getting out of hand:
    - the environment is going to be a 2d grid. This could be integers,
      and in many cases I'll assume integers, but I DON'T want to get
      pigeon-holed into thinking about *tiles*.
    - therefore the 2d grid is real numbers, and there's no foundational
      2d array of tiles. 
      - if I end up wanting tiles for, say, a map, that should be added
        as an abstraction - the world has-a map of tiles, not is-a map of tiles.
OTHER naming idea:
  - habitat
  - 
BAD/NON naming ideas:
  - env / environment. Overloaded and non-descriptive

_*/
export class Biome {
  constructor(opts) {
    /*
    I don't think I need to consider w/h bounds atm. I'm not rendering, and if I do,
      I can add it then, or just not render stuff out of bounds.
    _*/
    // this.w = opts?.w ?? 2160;
    // this.h = opts?.h ?? 3840;
    // this.w = opts?.w ?? 480;
    // this.h = opts?.h ?? 640;
    this.origin = new Point(0, 0);
    /*
    My current thinking is, an entity is anything.
      e.g.: microbes, food, obstructions
    maybe some things are not entities; like forces, zones, events,
      properties, ...
    _*/
    this.entities = [];
  }
  /* a la love2d */
  update(cb) {

  }
}
