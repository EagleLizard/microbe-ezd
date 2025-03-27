
/* abstract/superclass */
let eidCounter = 0;
export class Entity {
  constructor() {
    this.id = eidCounter++;
  }
}
