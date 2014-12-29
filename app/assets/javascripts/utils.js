
utils = {
  // String Utils
  capitalize: function(str){
    return str.substr(0, 1).toUpperCase() + str.substring(1).toLowerCase();
  },

  humanize: function(str){
    return this.capitalize(str.replace(/_/g, ' ').trim());
  }
}

module.exports = utils;