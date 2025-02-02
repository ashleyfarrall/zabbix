<?php declare(strict_types = 1);
/*
** Zabbix
** Copyright (C) 2001-2021 Zabbix SIA
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
**/


/**
 * @var CView $this
 */
?>

window.service_edit_popup = {
	algorithm_names: <?= json_encode(CServiceHelper::getAlgorithmNames(), JSON_FORCE_OBJECT) ?>,

	child_template: null,
	serviceid: null,
	overlay: null,
	dialogue: null,
	form: null,

	init({serviceid, children, children_problem_tags_html, problem_tags}) {
		this.child_template = new Template(`
			<tr>
				<td class="<?= ZBX_STYLE_WORDWRAP ?>" style="max-width: <?= ZBX_TEXTAREA_BIG_WIDTH ?>px;">
					#{name}
					<input name="child_serviceids[#{serviceid}]" type="hidden" value="#{serviceid}">
				</td>
				<td>#{algorithm}</td>
				<td class="<?= ZBX_STYLE_WORDWRAP ?>">#{*problem_tags_html}</td>
				<td>
					<button type="button" class="<?= ZBX_STYLE_BTN_LINK ?> js-remove"><?= _('Remove') ?></button>
				</td>
			</tr>
		`);

		this.serviceid = serviceid;
		this.overlay = overlays_stack.getById('service_edit');
		this.dialogue = this.overlay.$dialogue[0];
		this.form = this.overlay.$dialogue.$body[0].querySelector('form');

		// Setup Tabs.

		const $tabs = $('#tabs');

		$tabs.tabs();
		$tabs.on('tabsactivate', () => {
			$tabs.resize();
		});

		// Add custom Select button for Parent services.

		jQuery('#parent_serviceids_')
			.multiSelect('getSelectButton')
			.addEventListener('click', () => {
				this.selectParents();
			});

		// Fill-in current Child services.
		for (const service of children) {
			this.addChild({
				serviceid: service.serviceid,
				name: service.name,
				algorithm: service.algorithm,
				problem_tags_html: children_problem_tags_html[service.serviceid]
			});
		}

		// Setup Tags.

		const $tags = jQuery(document.getElementById('tags-table'));

		$tags.dynamicRows({template: '#tag-row-tmpl'});
		$tags.on('click', '.element-table-add', () => {
			$tags
				.find('.<?= ZBX_STYLE_TEXTAREA_FLEXIBLE ?>')
				.textareaFlexible();
		});

		// Update form field state according to the form data.

		for (const id of ['advanced_configuration', 'propagation_rule', 'algorithm', 'showsla']) {
			document
				.getElementById(id)
				.addEventListener('change', () => this.update());
		}

		this.update();

		// Setup Problem tags.
		jQuery(document.getElementById('problem_tags')).dynamicRows({
			template: '#problem-tag-row-tmpl',
			rows: problem_tags
		});

		// Setup Service rules.
		document
			.getElementById('status_rules')
			.addEventListener('click', (e) => {
				if (e.target.classList.contains('js-add')) {
					this.editStatusRule();
				}
				else if (e.target.classList.contains('js-edit')) {
					this.editStatusRule(e.target.closest('tr'));
				}
				else if (e.target.classList.contains('js-remove')) {
					e.target.closest('tr').remove();
				}
			});

		// Setup Service times.
		document
			.getElementById('times')
			.addEventListener('click', (e) => {
				if (e.target.classList.contains('js-add')) {
					this.editTime();
				}
				else if (e.target.classList.contains('js-edit')) {
					this.editTime(e.target.closest('tr'));
				}
				else if (e.target.classList.contains('js-remove')) {
					e.target.closest('tr').remove();
				}
			});

		// Setup Child services.
		document
			.getElementById('children')
			.addEventListener('click', (e) => {
				if (e.target.classList.contains('js-add')) {
					this.selectChildren();
				}
				else if (e.target.classList.contains('js-remove')) {
					e.target.closest('tr').remove();
				}
			});
	},

	update() {
		const advanced_configuration = document.getElementById('advanced_configuration').checked;
		const propagation_rule = document.getElementById('propagation_rule').value;
		const status_enabled = document.getElementById('algorithm').value != <?= ZBX_SERVICE_STATUS_CALC_SET_OK ?>;
		const showsla = document.getElementById('showsla').checked;

		document.getElementById('additional_rules_label').style.display = advanced_configuration ? '' : 'none';
		document.getElementById('additional_rules_field').style.display = advanced_configuration ? '' : 'none';
		document.getElementById('status_propagation_rules_label').style.display = advanced_configuration ? '' : 'none';
		document.getElementById('status_propagation_rules_field').style.display = advanced_configuration ? '' : 'none';
		document.getElementById('status_propagation_value_field').style.display = advanced_configuration ? '' : 'none';
		document.getElementById('weight_label').style.display = advanced_configuration ? '' : 'none';
		document.getElementById('weight_field').style.display = advanced_configuration ? '' : 'none';

		switch (propagation_rule) {
			case '<?= ZBX_SERVICE_STATUS_PROPAGATION_INCREASE ?>':
			case '<?= ZBX_SERVICE_STATUS_PROPAGATION_DECREASE ?>':
				document.getElementById('propagation_value_number').style.display = '';
				document.getElementById('propagation_value_status').style.display = 'none';
				break;

			case '<?= ZBX_SERVICE_STATUS_PROPAGATION_FIXED ?>':
				document.getElementById('propagation_value_number').style.display = 'none';
				document.getElementById('propagation_value_status').style.display = '';
				break;

			default:
				document.getElementById('propagation_value_number').style.display = 'none';
				document.getElementById('propagation_value_status').style.display = 'none';
				document.getElementById('status_propagation_value_field').style.display = 'none';
		}

		document.getElementById('showsla').disabled = !status_enabled;
		document.getElementById('goodsla').disabled = !status_enabled || !showsla;
	},

	editStatusRule(row = null) {
		let popup_params;

		if (row !== null) {
			const row_index = row.dataset.row_index;

			popup_params = {
				edit: '1',
				row_index,
				new_status: row.querySelector(`[name="status_rules[${row_index}][new_status]"`).value,
				type: row.querySelector(`[name="status_rules[${row_index}][type]"`).value,
				limit_value: row.querySelector(`[name="status_rules[${row_index}][limit_value]"`).value,
				limit_status: row.querySelector(`[name="status_rules[${row_index}][limit_status]"`).value
			};
		}
		else {
			let row_index = 0;

			while (document.querySelector(`#status_rules [data-row_index="${row_index}"]`) !== null) {
				row_index++;
			}

			popup_params = {row_index};
		}

		const overlay = PopUp('popup.service.statusrule.edit', popup_params, 'service_status_rule_edit',
			document.activeElement
		);

		overlay.$dialogue[0].addEventListener('dialogue.submit', (e) => {
			const new_row = e.detail;

			if (row !== null) {
				row.insertAdjacentHTML('afterend', new_row);
				row.remove();
			}
			else {
				document
					.querySelector('#status_rules tbody')
					.insertAdjacentHTML('beforeend', new_row);
			}
		});
	},

	editTime(row = null) {
		let popup_params;

		if (row !== null) {
			const row_index = row.dataset.row_index;

			popup_params = {
				edit: '1',
				row_index,
				type: row.querySelector(`[name="times[${row_index}][type]"`).value,
				ts_from: row.querySelector(`[name="times[${row_index}][ts_from]"`).value,
				ts_to: row.querySelector(`[name="times[${row_index}][ts_to]"`).value,
				note: row.querySelector(`[name="times[${row_index}][note]"`).value
			};
		}
		else {
			let row_index = 0;

			while (document.querySelector(`#times [data-row_index="${row_index}"]`) !== null) {
				row_index++;
			}

			popup_params = {row_index};
		}

		const overlay = PopUp('popup.service.time.edit', popup_params, 'service_time_edit', document.activeElement);

		overlay.$dialogue[0].addEventListener('dialogue.submit', (e) => {
			const new_row = e.detail;

			if (row !== null) {
				row.insertAdjacentHTML('afterend', new_row);
				row.remove();
			}
			else {
				document
					.querySelector('#times tbody')
					.insertAdjacentHTML('beforeend', new_row);
			}
		});
	},

	addChild(service) {
		if (document.querySelector(`#children tbody input[name="child_serviceids[${service.serviceid}]"]`) !== null) {
			return;
		}

		document
			.querySelector('#children tbody')
			.insertAdjacentHTML('beforeend', this.child_template.evaluate({
				serviceid: service.serviceid,
				name: service.name,
				algorithm: this.algorithm_names[service.algorithm],
				problem_tags_html: service.problem_tags_html
			}));
	},

	selectChildren() {
		const exclude_serviceids = [];

		if (this.serviceid !== null) {
			exclude_serviceids.push(this.serviceid);
		}

		for (const input of this.form.querySelectorAll('#children tbody input')) {
			exclude_serviceids.push(input.value);
		}

		const overlay = PopUp('popup.services', {
			title: <?= json_encode(_('Add child services')) ?>,
			exclude_serviceids
		}, 'services', document.activeElement);

		overlay.$dialogue[0].addEventListener('dialogue.submit', (e) => {
			for (const service of e.detail) {
				this.addChild(service);
			}
		});
	},

	selectParents() {
		const exclude_serviceids = [];

		if (this.serviceid !== null) {
			exclude_serviceids.push(this.serviceid);
		}

		for (const service of jQuery('#parent_serviceids_').multiSelect('getData')) {
			exclude_serviceids.push(service.id);
		}

		const overlay = PopUp('popup.services', {
			title: <?= json_encode(_('Add parent services')) ?>,
			exclude_serviceids
		}, 'services', document.activeElement);

		overlay.$dialogue[0].addEventListener('dialogue.submit', (e) => {
			const data = [];

			for (const service of e.detail) {
				data.push({id: service.serviceid, name: service.name});
			}

			jQuery('#parent_serviceids_').multiSelect('addData', data);
		});
	},

	submit() {
		const fields = getFormFields(this.form);

		fields.name = fields.name.trim();

		for (const el of this.form.parentNode.children) {
			if (el.matches('.msg-good, .msg-bad, .msg-warning')) {
				el.parentNode.removeChild(el);
			}
		}

		this.overlay.setLoading();

		const curl = new Curl(this.form.getAttribute('action'));

		fetch(curl.getUrl(), {
			method: 'POST',
			headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
			body: urlEncodeData(fields)
		})
			.then((response) => response.json())
			.then((response) => {
				if ('errors' in response) {
					throw {html_string: response.errors};
				}

				overlayDialogueDestroy(this.overlay.dialogueid);

				this.dialogue.dispatchEvent(new CustomEvent('dialogue.submit', {
					detail: {
						title: response.title,
						messages: ('messages' in response) ? response.messages : null
					}
				}));
			})
			.catch((error) => {
				let message_box;

				if (typeof error === 'object' && 'html_string' in error) {
					message_box =
						new DOMParser().parseFromString(error.html_string, 'text/html').body.firstElementChild;
				}
				else {
					const error = <?= json_encode(_('Unexpected server error.')) ?>;

					message_box = makeMessageBox('bad', [], error, true, false)[0];
				}

				this.form.parentNode.insertBefore(message_box, this.form);
			})
			.finally(() => {
				this.overlay.unsetLoading();
			});
	}
};
