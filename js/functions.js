document.addEventListener('DOMContentLoaded', () => {
    const fieldsets = document.querySelectorAll('fieldset.group-fieldset');
    if (fieldsets.length < 2) return;
    setupGroup(fieldsets[0], 'horario[dia_semana][]', ['Todos', 'Dias de semana']);
    setupGroup(fieldsets[1], 'info[tipo_vehiculo][]', []);
});

function setupGroup(fs, selectName, specials) {
    const tpl = fs.querySelector('.group-row').cloneNode(true);

    // Listener general para los botones
    fs.addEventListener('click', e => {
        if (e.target.matches('.btn-add')) {
            e.preventDefault();
            addRow(fs, tpl, selectName, specials);
        }
        if (e.target.matches('.btn-remove')) {
            e.preventDefault();
            removeRow(fs, e, tpl, selectName, specials);
        }
    });

    // Listener general para cambios en los inputs dentro del fieldset
    fs.addEventListener('change', e => {
        const row = e.target.closest('.group-row');
        if (!row) return;

        // Lógica para el <select> principal (días de la semana)
        if (e.target.matches(`select[name="${selectName}"]`)) {
            if (row.querySelector('input[type="time"]')) {
                // ✅ INICIO DE LA CORRECCIÓN
                // Se define una lógica más granular para manejar los casos especiales.
                const selectedValue = e.target.value;
                const is247 = selectedValue === 'Todos';
                const showTimeInputs = !!selectedValue && !is247;
                const showCerradoCheck = !!selectedValue && !specials.includes(selectedValue);

                const timeInputs = row.querySelectorAll('input[type="time"]');
                const cerradoCheck = row.querySelector('.chk-cerrado');
                const cerradoLabel = cerradoCheck ? cerradoCheck.closest('.chk-label') : null;

                // Controla la visibilidad de los inputs de HORA
                timeInputs.forEach(i => {
                    i.style.display = showTimeInputs ? '' : 'none';
                    i.disabled = !showTimeInputs;
                    if (!showTimeInputs) i.value = '';
                });

                // Controla la visibilidad del checkbox de CERRADO
                if (cerradoLabel) {
                    cerradoLabel.style.display = showCerradoCheck ? 'flex' : 'none';
                    if (!showCerradoCheck && cerradoCheck.checked) {
                        cerradoCheck.checked = false;
                        cerradoCheck.dispatchEvent(new Event('change', { bubbles: true }));
                    }
                }
                // ✅ FIN DE LA CORRECCIÓN
            }
            updateOptions(fs, selectName, specials);
        }

        // Lógica para el checkbox "Cerrado"
        if (e.target.matches('.chk-cerrado')) {
            const label = e.target.closest('.chk-label');
            if (label) {
                label.classList.toggle('is-checked', e.target.checked);
            }
            const timeInputs = row.querySelectorAll('input[type="time"]');
            if (e.target.checked) {
                timeInputs.forEach(i => {
                    i.disabled = true;
                    i.value = '';
                });
            } else {
                timeInputs.forEach(i => {
                    i.disabled = false;
                });
            }
        }
    });

    // Oculta el checkbox en la fila inicial al cargar la página.
    if (selectName.includes('horario')) {
        const initialCheckboxLabel = fs.querySelector('.chk-label');
        if (initialCheckboxLabel) {
            initialCheckboxLabel.style.display = 'none';
        }
    }

    updateOptions(fs, selectName, specials);
}

function addRow(fs, tpl, selectName, specials) {
    const rows = fs.querySelectorAll('.group-row');
    const cur = rows[rows.length - 1];
    const sel = cur.querySelector(`select[name="${selectName}"]`);
    const val = sel.value;
    if (!val) {
        alert('Selecciona una opción antes de añadir.');
        return;
    }

    const isHor = !!cur.querySelector('.chk-cerrado');
    const isInf = !!cur.querySelector('input[name="info[tarifa][]"]');

    if (isHor && !specials.includes(val)) {
        const isChecked = cur.querySelector('.chk-cerrado').checked;
        const [o, c] = [...cur.querySelectorAll('input[type="time"]')].map(i => i.value);
        if (!isChecked && (!o || !c)) {
            alert('Debes indicar apertura y cierre, o marcar la casilla "Cerrado".');
            return;
        }
    }
    // Añadimos validación para el caso "Dias de semana"
    if (isHor && val === 'Dias de semana') {
        const [o, c] = [...cur.querySelectorAll('input[type="time"]')].map(i => i.value);
        if (!o || !c) {
            alert('Debes indicar apertura y cierre para los días de semana.');
            return;
        }
    }
    if (isInf) {
        const t = cur.querySelector('input[name="info[tarifa][]"]').value.trim();
        const c = cur.querySelector('input[name="info[capacidad][]"]').value.trim();
        if (!t || !c) {
            alert('Tarifa y capacidad son obligatorios.');
            return;
        }
    }

    const chkCerrado = cur.querySelector('.chk-cerrado');
    if (chkCerrado && !chkCerrado.checked) {
        const chkLabel = chkCerrado.closest('.chk-label');
        if (chkLabel) {
            chkLabel.style.display = 'none';
        }
    }

    disableControls(cur);
    transformBtn(cur, 'btn-remove', '✕');

    if (isHor && specials.includes(val)) {
        updateOptions(fs, selectName, specials);
        checkAndRemoveLastRow(fs);
        return;
    }

    const nr = createNewRow(tpl);
    fs.appendChild(nr);

    updateOptions(fs, selectName, specials);
    checkAndRemoveLastRow(fs);
}

function removeRow(fs, event, tpl, selectName, specials) {
    const rowToRemove = event.target.closest('.group-row');
    rowToRemove.remove();
    updateOptions(fs, selectName, specials);

    if (!fs.querySelector('.btn-add')) {
        const freshRow = createNewRow(tpl);
        fs.appendChild(freshRow);
        updateOptions(fs, selectName, specials);
    }
}

function createNewRow(tpl) {
    const newRow = tpl.cloneNode(true);
    newRow.querySelectorAll('input, select').forEach(el => {
        el.disabled = false;
        el.style.display = '';
        switch (el.type) {
            case 'select-one':
                el.selectedIndex = 0;
                break;
            case 'checkbox':
                el.checked = false;
                break;
            default:
                el.value = '';
                break;
        }
    });

    const chkLabel = newRow.querySelector('.chk-label');
    if (chkLabel) {
        chkLabel.style.display = 'none';
        chkLabel.classList.remove('is-checked');
    }

    transformBtn(newRow, 'btn-add', 'Añadir');
    return newRow;
}

function disableControls(row) {
    row.querySelectorAll('input, select').forEach(el => el.disabled = true);
}

function transformBtn(row, cls, text) {
    const old = row.querySelector('button');
    const b = document.createElement('button');
    b.type = 'button';
    b.className = cls;
    b.textContent = text;
    old.replaceWith(b);
}

function updateOptions(fs, selectName, specials) {
    const sels = Array.from(fs.querySelectorAll(`select[name="${selectName}"]`));
    const used = sels.map(s => s.value).filter(v => v);

    sels.forEach(sel => {
        if (sel.disabled) return;
        Array.from(sel.options).forEach(opt => {
            if (!opt.value) return;
            let dis = false;
            if (used.includes(opt.value)) dis = true;
            if (specials.includes(opt.value) && used.some(u => !specials.includes(u))) dis = true;
            if (!specials.includes(opt.value) && used.some(u => specials.includes(u))) dis = true;
            opt.disabled = dis;
        });
    });
}

function checkAndRemoveLastRow(fs) {
    const lastRow = fs.querySelector('.group-row:last-child');
    if (!lastRow || !lastRow.querySelector('.btn-add')) {
        return;
    }
    const lastSelect = lastRow.querySelector('select');
    const availableOptions = Array.from(lastSelect.options)
        .filter(opt => opt.value && !opt.disabled);
    if (availableOptions.length === 0) {
        lastRow.remove();
    }
}