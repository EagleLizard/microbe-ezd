
export {
  $, 
}

function $(query: string, parentNode: ParentNode = document) {
  let el = parentNode.querySelector(query);
  return el;
}

$.all = (query: string, parentNode: ParentNode = document) => {
  let els = parentNode.querySelectorAll(query);
  return Array.from(els);
}

$.ready = (cb: () => void) => {
  if(document.readyState !== 'loading') {
    return cb();
  }
  return document.addEventListener('DOMContentLoaded', cb);
}
