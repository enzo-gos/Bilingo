import { Controller } from '@hotwired/stimulus';
import MediumEditor from 'medium-editor';

// Connects to data-controller="editor"
export default class extends Controller {
  connect() {
    (function () {
      'use strict';

      var CLASS_DRAG_OVER = 'medium-editor-dragover';

      function clearClassNames(element) {
        var editable = MediumEditor.util.getContainerEditorElement(element),
          existing = Array.prototype.slice.call(editable.parentElement.querySelectorAll('.' + CLASS_DRAG_OVER));

        existing.forEach(function (el) {
          el.classList.remove(CLASS_DRAG_OVER);
        });
      }

      var FileDragging2 = MediumEditor.Extension.extend({
        name: 'fileDragging',
        allowedTypes: ['image'],

        init: function () {
          MediumEditor.Extension.prototype.init.apply(this, arguments);

          this.subscribe('editableDrag', this.handleDrag.bind(this));
          this.subscribe('editableDrop', this.handleDrop.bind(this));
        },
        handleDrag: function (event) {
          event.preventDefault();
          event.dataTransfer.dropEffect = 'copy';

          var target = event.target.classList ? event.target : event.target.parentElement;

          clearClassNames(target);

          if (event.type === 'dragover') {
            target.classList.add(CLASS_DRAG_OVER);
          }
        },
        handleDrop: function (event) {
          event.preventDefault();
          event.stopPropagation();
          this.base.selectElement(event.target);
          var selection = this.base.exportSelection();
          selection.start = selection.end;
          this.base.importSelection(selection);
          if (event.dataTransfer.files) {
            Array.prototype.slice.call(event.dataTransfer.files).forEach(function (file) {
              if (this.isAllowedFile(file)) {
                if (file.type.match('image')) {
                  this.insertImageFile(file);
                }
              }
            }, this);
          }
          clearClassNames(event.target);
        },
        isAllowedFile: function (file) {
          return this.allowedTypes.some(function (fileType) {
            return !!file.type.match(fileType);
          });
        },
        insertImageFile: function (file) {
          if (typeof FileReader !== 'function') {
            return;
          }
          var fileReader = new FileReader();
          fileReader.readAsDataURL(file);

          var self = this;
          fileReader.addEventListener(
            'load',
            function (e) {
              self.sendBlobToAPI(e.target.result);
            }.bind(this)
          );
        },
        sendBlobToAPI: function (blob) {
          // console.log("send image file to api", blob);
          var self = this;
          var data = { image: blob };
          var api = '/api/media/images';
          var method = 'post';

          self.serverRequest = $.ajax({
            url: api,
            method: method,
            data: data,
          }).then(function (response) {
            // var src = response.responseText;
            // var addImageElement = self.document.createElement('img');
            // addImageElement.src = src;
            // MediumEditor.util.insertHTMLCommand(self.document, addImageElement.outerHTML);
          });

          var addImageElement = self.document.createElement('img');
          addImageElement.src = blob;
          MediumEditor.util.insertHTMLCommand(self.document, addImageElement.outerHTML);
        },
      });
      MediumEditor.extensions.fileDragging = FileDragging2;
    })();

    const editor = new MediumEditor('.editable', {
      toolbar: {
        allowMultiParagraphSelection: true,
        buttons: [
          {
            name: 'bold',
            contentDefault: '<i class="material-icons md-18">format_bold</i>',
          },
          {
            name: 'italic',
            contentDefault: '<i class="material-icons md-18">format_italic</i>',
          },
          {
            name: 'underline',
            contentDefault: '<i class="material-icons md-18">format_underlined</i>',
          },
          {
            name: 'justifyLeft',
            contentDefault: '<i class="material-icons md-18">format_align_left</i>',
          },
          {
            name: 'justifyCenter',
            contentDefault: '<i class="material-icons md-18">format_align_center</i>',
          },
          {
            name: 'justifyRight',
            contentDefault: '<i class="material-icons md-18">format_align_right</i>',
          },
        ],
        diffLeft: 0,
        diffTop: -10,
        firstButtonClass: 'medium-editor-button-first',
        lastButtonClass: 'medium-editor-button-last',
        relativeContainer: null,
        standardizeSelectionStart: false,
        static: false,
        /* options which only apply when static is true */
        align: 'center',
        sticky: false,
        updateOnEmptySelection: false,
      },
      imageDragging: true,
      extensions: {
        insert: createInsertPlugin({
          buttons: ['insert-image'],
        }),
      },
    });
  }
}

function createInsertPlugin(options) {
  const Insert = MediumEditor.Extension.extend({
    name: 'insert',
    init: function () {
      MediumEditor.Extension.prototype.init.apply(this, arguments);

      this.subscribe('editableKeydown', this.handleKeydown.bind(this));
      this.subscribe('editableClick', this.handleKeydown.bind(this));
    },
    handleKeydown: function () {
      var self = this;
      requestAnimationFrame(function () {
        var selection = self.getSelection(),
          node;

        if (!selection || !selection.anchorNode) {
          self.hideButtons();
          return;
        }

        node = selection.anchorNode;

        while (node.nodeType !== 1 && node) {
          node = node.parentNode;
        }

        if (!node) {
          self.hideButtons();
          return;
        }

        if (node.innerText.replace(/^\s+|\s+$/g, '').length > 0) {
          self.hideButtons();
          return;
        }
        self._selection = selection;
        self._focusedNode = node;
        self.showButtons(node);
      });
    },
    getSelection: function () {
      if (window.getSelection) {
        return window.getSelection();
      } else if (document.getSelection) {
        return document.getSelection();
      } else if (document.selection) {
        return document.selection.createRange().text;
      }
    },
    hideButtons: function (node) {
      this.getPlusIcon().style.display = 'none';
    },
    showButtons: function (node) {
      var buttons = this.getPlusIcon();

      var box = node.getBoundingClientRect(),
        xOffset = window.scrollX,
        yOffset = window.scrollY,
        x = box.left + xOffset - 70,
        y = box.top + yOffset;

      buttons.style.top = y + 'px';
      buttons.style.left = x + 'px';

      buttons.style.display = 'block';
      buttons.style.opacity = 1;
    },
    getPlusIcon: function () {
      if (!this._buttons) {
        this._buttons = document.createElement('a');
        this._buttons.innerHTML = `<div class="flex gap-2 items-center">
          <i class="material-icons">image</i>
          <i class="material-icons">attachment</i>
        </div>`;
        this._buttons.style.cursor = 'pointer';
        this._buttons.style.display = 'none';
        this._buttons.style.position = 'absolute';
        this._buttons.style.opacity = 0;
        this._buttons.setAttribute('data-me-insert-buttons', '');
        document.body.appendChild(this._buttons);
      }
      return this._buttons;
    },
  });

  return new Insert(options);
}
