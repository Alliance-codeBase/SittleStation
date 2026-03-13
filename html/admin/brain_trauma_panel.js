function updateBrainTraumaModeUi() {
  const exactMode = document.getElementById("bt_mode_exact");
  const categoryMode = document.getElementById("bt_mode_category");
  const exactWrap = document.getElementById("bt_exact_wrap");
  const categoryWrap = document.getElementById("bt_category_wrap");
  const exactSelect = document.getElementById("bt_trauma_path");
  const categorySelect = document.getElementById("bt_trauma_category");
  const traumaCountInput = document.getElementById("bt_trauma_count");

  if (!exactMode || !categoryMode || !exactWrap || !categoryWrap) {
    return;
  }

  const exactSelected = exactMode.checked;
  exactWrap.style.display = exactSelected ? "block" : "none";
  categoryWrap.style.display = exactSelected ? "none" : "block";

  if (exactSelect) {
    exactSelect.disabled = !exactSelected;
  }
  if (categorySelect) {
    categorySelect.disabled = exactSelected;
  }
  if (traumaCountInput) {
    traumaCountInput.disabled = exactSelected;
  }
}

function updateBrainTraumaDurationUi() {
  const temporary = document.getElementById("bt_duration_temporary");
  const valueInput = document.getElementById("bt_duration_value");
  const intervalSelect = document.getElementById("bt_interval");

  if (!temporary || !valueInput || !intervalSelect) {
    return;
  }

  const enabled = temporary.checked;
  valueInput.disabled = !enabled;
  intervalSelect.disabled = !enabled;
}

function initBrainTraumaPanelUi() {
  const exactMode = document.getElementById("bt_mode_exact");
  const categoryMode = document.getElementById("bt_mode_category");
  const permanent = document.getElementById("bt_duration_permanent");
  const temporary = document.getElementById("bt_duration_temporary");

  if (exactMode) {
    exactMode.addEventListener("change", updateBrainTraumaModeUi);
  }
  if (categoryMode) {
    categoryMode.addEventListener("change", updateBrainTraumaModeUi);
  }
  if (permanent) {
    permanent.addEventListener("change", updateBrainTraumaDurationUi);
  }
  if (temporary) {
    temporary.addEventListener("change", updateBrainTraumaDurationUi);
  }

  updateBrainTraumaModeUi();
  updateBrainTraumaDurationUi();
}

document.addEventListener("DOMContentLoaded", initBrainTraumaPanelUi);
