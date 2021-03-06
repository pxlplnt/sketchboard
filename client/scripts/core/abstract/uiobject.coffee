class UIObject extends Observable

    DOMEvents: ["mouseover", "mouseout", "click", "mousedown", "mouseup", "mousemove", "submit"]

    constructor: ->
        super

        @events.push "move", "add", "remove", "show", "hide", "render"
        @properties = new PropertySet()

        @create.apply @, arguments

    create: (conf) ->
        @el = new Element conf
        @position =
            x: 0
            y: 0

        @raise "render", @

    draggable: (opts) ->
        @el.draggable opts

    on: (name, clb) ->
        if name in @DOMEvents
            @el.on(name, clb)

            return

        super

    un: (name, clb) ->
        if name in @DOMEvents
            @el.un(name, clb)

    raise: ->
        name = arguments[0]
        args = ($ arguments).slice 1

        if name in @DOMEvents
            @el.raise.apply @el, [name].concat args

            return

        super

    update: ->
        @position =
            x: @el.left()
            y: @el.top()

    add: (child) ->
        @el.insert child.el

        @raise "add", @

    remove: ->
        @el.remove()

        @raise "remove", @

    getWidth: ->
        @el.getWidth()

    getHeight: ->
        @el.getHeight()

    moveTo: (coord) ->
        @el.moveTo coord

        @position = coord

        @raise "move", @, coord

    rotate: (deg, duration=0) ->
        @rotation = deg

        @el.rotate deg, duration

    getPosition: ->
        @position

    show: (effect) ->
        @el.show(effect)

        @hidden = no
        @raise "show", @

    visible: ->
        @el.visible()

    hide: (effect) ->
        @el.hide(effect)

        @hidden = yes
        @raise "hide", @

    proxy: ->
        origin = arguments[0]
        events = ($ arguments).slice 1

        for e in events
            @on e, ->
                args = $ arguments

                origin.raise.apply origin, [e].concat args