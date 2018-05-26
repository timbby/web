var app = new Vue({
    el: '#app',
    data: {
        message_list: [],
        new_message:  null
    },
    mounted: function () {
        var index = this;
        // 初始化数据
        index.initPage();
    },
    methods: {
        initPage: function () {
            var index = this;
            $.ajax({
                type: 'POST',
                url: '/api',
                data: {
                    'cmd': 'get_message_list'
                },
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=utf-8",
                success: function (data) {
                    index.$data.message_list = data.resp;
                }
            })
        },
        send_message: function () {
            var index = this;
            var message = this.$refs.input.value;
            if(message == ''){
                return
            }
            $.ajax({
                type: 'POST',
                url: '/api',
                data: {
                    'cmd': 'send_message',
                    'message': message
                },
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=utf-8",
                success: function (data) {
                    //index.$data.message_list = data.resp;
                    index.$refs.input.value  = '';
                    index.initPage();
                }
            })
        }
    }, watch: {
        // 'betAmount': function (curVal, oldVal) {
        //     var index = this;
        //     if (curVal > 500) {
        //         index.$data.betAmount = 500;
        //     }
        //     else if (curVal < 2) {
        //         index.$data.betAmount = 2;
        //     }
        // }
    }
});
