
import './main.css';
import { $ } from './dollar';

const templatesId = 'templates';
let templatesEl: Element | null  = null;

(() => {
  $.ready(main)
})();

function main() {
  let appEl = $('#app');
  let microbeEzd = getTemplate('#microbe-ezd');
  let microbeEzdHeader = document.createElement('h2')
  microbeEzdHeader.appendChild(document.createTextNode('Microbe EZD'))
  microbeEzd.appendChild(microbeEzdHeader);
  let menuEl = createMenu();
  microbeEzd.appendChild(menuEl);
  appEl?.appendChild(microbeEzd);
  console.log({appEl});
}

function createMenu() {
  let ezdMenuContainer = getTemplate('#ezd-menu-container');
  let ezdMenu = getTemplate('#ezd-menu');
  let ezdMenuItem = getTemplate('#ezd-menu-item');
  for(let i = 0; i < 10; ++i) {
    let nextMenuItem = ezdMenuItem.cloneNode();
    let menuItemLabel = `menu item ${i + 1}`;
    nextMenuItem.appendChild(document.createTextNode(menuItemLabel));
    nextMenuItem.addEventListener('click', ($e) => {
      console.log($e);
    });
    ezdMenu.appendChild(nextMenuItem)
  }
  ezdMenuContainer.appendChild(ezdMenu)
  return ezdMenuContainer;
}

function getTemplate(tid: string): HTMLElement {
  if(templatesEl === null) {
    templatesEl = $('#templates');
    if(templatesEl === null) {
      throw new Error(`couldn't get templates element`);
    }
  }
  let templateEl = $(`${tid}`, templatesEl);
  if(templateEl === null) {
    throw new Error(`Couldn't find template with id #${tid}`);
  }
  let templateClone = cloneEl(templateEl);
  /* remove */
  templateClone.removeAttribute('id');
  return templateClone;
}

/*
because TS doesn't add Node properties I expect for elements
_*/
function cloneEl(el: Element): HTMLElement {
  return el.cloneNode(true) as HTMLElement;
}
