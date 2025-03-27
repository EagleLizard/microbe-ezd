
import { Entity } from '../entity';

class Food extends Entity {
  constructor(opts) {
    super();
    this.kcal = opts?.kcal ?? 5;
  }
}
