'use strict';

module.exports = validationData;

let errors = [];

function validationData() {
    errors = [];
}

validationData.prototype.isRequired = (value, message) => {
    if (!value || value.length <= 0) {
        errors.push({ message: message })
    }
}

validationData.prototype.hasMinLen = (value, min, message) => {
    if (!value || value.length < min) {
        errors.push({ message: message });
    }
}

validationData.prototype.hasMaxLen = (value, max, message) => {
    if (!value || value.length > max) {
        errors.push({ message: message });
    }
}

validationData.prototype.isFixedLen = (value, len, message) => {
    if (value.length !== len) {
        errors.push({ message: message });
    }
}

validationData.prototype.isEmail = (value, message) => {
    var reg = new RegExp(/^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/);
    if (!reg.test(value)) {
        errors.push({ message: message });
    }
}

validationData.prototype.errors = () => {
    return errors;
}

validationData.prototype.clear = () => {
    errors = [];
}

validationData.prototype.isValid = () => {
    return errors.length === 0;
}

