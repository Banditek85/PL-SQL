function baz() {

    require(["require", "exports", "knockout", "ojs/ojbootstrap","https://apex.oracle.com/pls/apex/mitjas_workspace/r/43171/files/plugin/24880246128870169012/v9/foo.js"],
        function (require, exports, ko, ojbootstrap_1, foo) {
            class Greeting {
                constructor() {
                    this.data = "HELLO FROM MAIN.JS";
                }
            }
            
            console.log("I am loaded by the plugin, yeay!");

            console.log("this is from another file, required by Require.js")
            console.log(foo.color);

            // ko.applyBindings(new Greeting(), document.getElementById("explorer"));
        });
}