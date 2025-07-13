// js/register-logic.js

const FormLogic = {
    handleSelectChange: function (row, selectedValue) {
        if (!row) return;
        const timeInputs = row.querySelectorAll('input[type="time"]');
        if (timeInputs.length === 0) return;
        const is247 = selectedValue === 'Todos';
        const showTime = !!selectedValue && !is247;
        timeInputs.forEach(input => {
            input.style.display = showTime ? '' : 'none';
            input.disabled = !showTime;
            if (!showTime) input.value = '';
        });
    },
    updateOptions: function (fieldset, selectName, specialOptions) {
        const selects = Array.from(fieldset.querySelectorAll(`select[name="${selectName}"]`));
        if (selects.length === 0) return;

        const usedValues = selects.map(s => s.value).filter(Boolean);
        const isSpecialUsed = usedValues.some(v => specialOptions.includes(v));
        const isRegularUsed = usedValues.some(v => v && !specialOptions.includes(v));

        selects.forEach(select => {
            if (select.disabled) return;
            Array.from(select.options).forEach(option => {
                if (!option.value) return;
                let shouldBeDisabled = false;
                if (usedValues.includes(option.value) && option.value !== select.value) { shouldBeDisabled = true; }
                if (isSpecialUsed && !usedValues.includes(option.value)) { shouldBeDisabled = true; }
                if (isRegularUsed && specialOptions.includes(option.value)) { shouldBeDisabled = true; }
                option.disabled = shouldBeDisabled;
            });
        });

        const lastRow = fieldset.querySelector('.group-row:last-child');
        if (lastRow) {
            const lastAddButton = lastRow.querySelector('.btn-add');
            if (lastAddButton) {
                const lastSelect = lastRow.querySelector(`select[name="${selectName}"]`);
                const hasAvailableOptions = Array.from(lastSelect.options).some(opt => !opt.disabled && opt.value);
                lastAddButton.style.display = hasAvailableOptions ? '' : 'none';
            }
        }
    },
    createNewEmptyRow: function (templateRow) {
        const newRow = templateRow.cloneNode(true);
        newRow.querySelectorAll('input, select').forEach(input => {
            input.disabled = false;
            input.type === 'select-one' ? input.selectedIndex = 0 : input.value = '';
        });
        const removeBtn = newRow.querySelector('.btn-remove');
        if (removeBtn) {
            const addBtn = document.createElement('button');
            addBtn.type = 'button'; addBtn.className = 'btn-add'; addBtn.textContent = 'Añadir';
            removeBtn.replaceWith(addBtn);
        }
        return newRow;
    }
};

document.addEventListener('DOMContentLoaded', () => {

    function setupDynamicRows(fieldsetId, selectName, specialOptions = []) {
        const fieldset = document.getElementById(fieldsetId);
        if (!fieldset) return;
        const templateRow = fieldset.querySelector('.group-row')?.cloneNode(true);
        if (!templateRow) return;

        fieldset.addEventListener('click', (e) => {
            if (e.target.matches('.btn-add')) {
                e.preventDefault();
                addRow(fieldset, templateRow, selectName, specialOptions);
            }
            if (e.target.matches('.btn-remove')) {
                e.preventDefault();
                removeRow(fieldset, e, templateRow, selectName, specialOptions);
            }
        });

        fieldset.addEventListener('change', (e) => {
            const target = e.target;
            if (target.matches(`select[name="${selectName}"]`)) {
                FormLogic.handleSelectChange(target.closest('.group-row'), target.value);
            }
        });

        const firstRow = fieldset.querySelector('.group-row');
        if (firstRow) {
            FormLogic.handleSelectChange(firstRow, firstRow.querySelector(`select[name="${selectName}"]`).value);
            FormLogic.updateOptions(fieldset, selectName, specialOptions);
        }
    }

    function addRow(fieldset, templateRow, selectName, specialOptions) {
        const lastRow = fieldset.querySelector('.group-row:last-child');
        const lastSelect = lastRow.querySelector(`select[name="${selectName}"]`);

        if (!lastSelect.value) {
            alert('Por favor, selecciona una opción antes de añadir una nueva fila.');
            return;
        }

        if (fieldset.id === 'fieldset-horarios') {
            const selectedDay = lastSelect.value;
            if (selectedDay !== 'Todos') {
                const apertura = lastRow.querySelector('input[name="horario_apertura"]').value;
                const cierre = lastRow.querySelector('input[name="horario_cierre"]').value;
                if (!apertura || !cierre) {
                    alert('Debes indicar un horario de apertura y cierre para esta opción.');
                    return;
                }
            }
        }

        lastRow.querySelectorAll('input, select').forEach(el => el.disabled = true);
        const addButton = lastRow.querySelector('.btn-add');
        if (addButton) {
            const removeButton = document.createElement('button');
            removeButton.type = 'button'; removeButton.className = 'btn-remove'; removeButton.textContent = 'Quitar';
            addButton.replaceWith(removeButton);
        }

        if (specialOptions.includes(lastSelect.value)) {
            FormLogic.updateOptions(fieldset, selectName, specialOptions);
            checkAndRemoveLastRow(fieldset);
            return;
        }

        const newRow = FormLogic.createNewEmptyRow(templateRow);
        fieldset.appendChild(newRow);
        FormLogic.updateOptions(fieldset, selectName, specialOptions);
        checkAndRemoveLastRow(fieldset);
    }

    function removeRow(fieldset, event, templateRow, selectName, specialOptions) {
        event.target.closest('.group-row').remove();
        if (!fieldset.querySelector('.btn-add') && fieldset.querySelectorAll('.group-row').length > 0) {
            const freshRow = FormLogic.createNewEmptyRow(templateRow);
            fieldset.appendChild(freshRow);
        } else if (fieldset.querySelectorAll('.group-row').length === 0) {
            const freshRow = FormLogic.createNewEmptyRow(templateRow);
            fieldset.appendChild(freshRow);
        }
        FormLogic.updateOptions(fieldset, selectName, specialOptions);
    }

    function checkAndRemoveLastRow(fieldset) {
        const lastRow = fieldset.querySelector('.group-row:last-child');
        const lastAddButton = lastRow.querySelector('.btn-add');
        if (lastAddButton) {
            const lastSelect = lastRow.querySelector('select');
            const hasAvailableOptions = Array.from(lastSelect.options).some(opt => !opt.disabled && opt.value);
            if (!hasAvailableOptions) {
                lastRow.remove();
            }
        }
    }

    if (document.body.contains(document.getElementById('formParqueadero'))) {
        setupDynamicRows('fieldset-horarios', 'horario_dia_semana', ['Todos', 'Dias de semana']);
        setupDynamicRows('fieldset-info', 'info_tipo_vehiculo', []);

        const form = document.getElementById('formParqueadero');
        form.addEventListener('submit', function (event) {
            event.preventDefault();

            let hasValidHorario = false;
            let hasValidInfo = false;
            const horarios = [];
            const info = [];

            // Recolectar y validar horarios
            document.querySelectorAll('#fieldset-horarios .group-row').forEach(fila => {
                const diaSelect = fila.querySelector('select[name="horario_dia_semana"]');
                const apertura = fila.querySelector('input[name="horario_apertura"]');
                const cierre = fila.querySelector('input[name="horario_cierre"]');

                if (diaSelect && diaSelect.value) {
                    const esCompleto = (diaSelect.value === 'Todos') || (apertura.value && cierre.value);
                    if (esCompleto) {
                        hasValidHorario = true;
                    }
                    horarios.push({
                        dia_semana: diaSelect.value,
                        apertura: apertura.value,
                        cierre: cierre.value
                    });
                }
            });

            // Recolectar y validar info
            document.querySelectorAll('#fieldset-info .group-row').forEach(fila => {
                const tipoSelect = fila.querySelector('select[name="info_tipo_vehiculo"]');
                const tarifa = fila.querySelector('input[name="info_tarifa"]');
                const capacidad = fila.querySelector('input[name="info_capacidad"]');

                if (tipoSelect && tipoSelect.value) {
                    const esCompleto = tarifa.value && capacidad.value;
                    if (esCompleto) {
                        hasValidInfo = true;
                    }
                    info.push({
                        tipo_vehiculo: tipoSelect.value,
                        tarifa: tarifa.value,
                        capacidad: capacidad.value
                    });
                }
            });

            if (!hasValidHorario || !hasValidInfo) {
                alert('Debes registrar al menos un horario completo y un tipo de vehículo con su tarifa y capacidad.');
                return; // Detener el envío del formulario
            }

            document.getElementById('horarios_json').value = JSON.stringify(horarios);
            document.getElementById('info_json').value = JSON.stringify(info);
            form.submit();
        });
    }
});