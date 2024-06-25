import { Controller } from '@hotwired/stimulus';
import MediumEditor from 'medium-editor';
import { InsertPlugin, FileDraggingPlugin } from 'helpers/editor';
import debounce from 'lodash.debounce';

// Connects to data-controller="editor"
export default class extends Controller {
  static targets = ['content', 'title', 'titleEditor'];

  connect() {
    MediumEditor.extensions.fileDragging = FileDraggingPlugin;

    this.editor = new MediumEditor('.editable', {
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
      paste: {
        forcePlainText: false,
        cleanPastedHTML: true,
        cleanReplacements: [[new RegExp(/\s+data-[\w-]+=["'][^"']+["']/gi), '']],
        cleanAttrs: ['style', 'dir', 'id', 'onclick', 'onerror', 'onload', 'onmouseover', 'onsubmit', 'action'],
        cleanTags: [
          'meta',
          'link',
          'script',
          'style',
          'iframe',
          'frame',
          'embed',
          'object',
          'applet',
          'form',
          'input',
          'button',
          'a',
          'select',
          'option',
        ],
        unwrapTags: [],
      },
      extensions: {},
    });

    $(this.element).on('input', () => this.save());

    this.url = this.element.action;
    this.formData = new FormData(this.element);

    const requestDelay = () => this.sendRequest(this.url, this.formData);
    this.debouncedRequest = debounce(requestDelay, 2000);

    this.editor.subscribe('editableInput', () => {
      const element = this.editor.serialize()['element-0'];
      $(this.contentTarget).val(element.value);

      $('#word-count').html(`(${this.countWords()} words)`);
    });

    $(this.titleEditorTarget).on('input', () => {
      $(this.titleTarget).val($(this.titleEditorTarget).html());
    });

    if (this.editor.getContent()) $('#word-count').html(`(${this.countWords()} words)`);
  }

  savingStatus() {
    $('#save-status').removeClass('saved-status');
    $('#save-status').addClass('saving-status');

    $('#save-status').html('Saving...');
  }

  savedStatus() {
    $('#save-status').removeClass('saving-status');
    $('#save-status').addClass('saved-status');

    $('#save-status').html('Saved');
  }

  save() {
    if (this.data.get('autosave') === 'true') {
      this.savingStatus();
      this.formData = new FormData(this.element);
      this.debouncedRequest(this.url, this.formData);
    }
  }

  sendRequest(url, formData) {
    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        Accept: 'application/json',
      },
      credentials: 'same-origin',
      body: formData,
    }).then((response) => {
      response.json().then((chapter) => {
        console.log(chapter);
        $('.toolbar-heading-info .story-name').html(chapter.title);
        $('.chapter-info .chapter-title').html(chapter.title);

        const date = new Date(chapter.updated_at);
        const options = { year: 'numeric', month: 'short', day: 'numeric' };
        const formattedDate = new Intl.DateTimeFormat('en-US', options).format(date);

        $('.chapter-info .chapter-status small').html(formattedDate);
        this.savedStatus();
      });
    });
  }

  countWords() {
    const text = this.editor
      .getContent()
      .replace(/<[^>]*>/g, '')
      .replace(/&nbsp;/g, ' ')
      .replace(/(^\s*)|(\s*$)/gi, '')
      .replace(/[ ]{2,}/gi, ' ')
      .replace(/\n /, '\n');

    const words = text.split(' ').filter(function (word) {
      return word.length > 0;
    });

    return words.length;
  }
}
