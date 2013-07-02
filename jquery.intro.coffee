class jQueryIntroJs
  constructor: (steps) ->
    @steps = $.extend [], steps
    @currentStep = 0
    return unless @steps.length > 0
    @start()

  start: ->
    @addOverlay()
    @addHelperLayer()
    @showCurrentStep()

    $(document).on "keydown.introjs", ((e) => @keydown(e))
    $(document).on "click.introjs", ".introjs-nextbutton", (=> @nextStep())
    $(document).on "click.introjs", ".introjs-skipbutton", (=> @endTour())

  keydown: (e) ->
    switch e.keyCode
      when 27 then @endTour()
      when 37 then @previousStep()
      when 39 then @nextStep()

  addOverlay: ->
    @$overlayDiv = $("<div class='introjs-overlay'></div>")

    @$overlayDiv.on "click", =>
      @endTour()

    @$overlayDiv.appendTo("body")

    @$overlayDiv.animate
      opacity: 0.5
    , 10

  addHelperLayer: ->
    @$helperLayerDiv = $("""
      <div class="introjs-helperLayer">
        <span class="introjs-helperNumberLayer"></span>
      </div>
    """)

    @$helperLayerDiv.appendTo("body")

  setHelperLayer: ($el, text, placement = 'bottom', minWidth = false) ->
    @$helperLayerDiv.popover('destroy')

    if $el
      @$helperLayerDiv.css
        width: $el.outerWidth() + 10
        height: $el.outerHeight() + 10
        top: $el.offset().top - 5
        left: $el.offset().left - 5
        opacity: '1'
        'margin-left': ''

    else
      @$helperLayerDiv.css
        width: '300px'
        height: '0px'
        top: '50px'
        left: '50%'
        'margin-left': '-150px'
        opacity: '0'

    @$helperLayerDiv.find(".introjs-helperNumberLayer").text(@currentStep + 1)

    setTimeout =>
      @$helperLayerDiv.popover
        content: text
        trigger: 'manual'
        template: """
          <div class="popover">
            #{if placement != 'none' then "<div class='arrow'></div>" else ""}
            <div class="popover-inner">
              <div class="popover-content">
                <p></p>
              </div>
              <div class="introjs-tooltipbuttons">
                <a class="introjs-skipbutton">Skip</a>
                <a class="introjs-nextbutton">#{if @steps[@currentStep + 1]? then 'Next →' else 'Done!'}</a>
              </div>
            </div>
          </div>
        """
        placement: if placement == 'none' then 'bottom' else placement

      @$helperLayerDiv.popover('show')

    , 325

  showCurrentStep: ->
    step = @steps[@currentStep]

    if typeof step['el'] == 'function'
      $el = step['el']().slice(0, 1)
    else if step['el'] != 'full'
      $el = $(step['el']).slice(0, 1)

    if step['el'] != 'full' && $el.length == 0
      @steps.splice(@currentStep, 1)
      return (if @steps.length == @currentStep then @endTour() else @showCurrentStep())

    @setHelperLayer($el, step['text'], step['placement'], step['minWidth'])
    setTimeout =>
      $el?.addClass('introjs-showElement')
    , 200

    if !@steps[@currentStep + 1]?
      @$helperLayerDiv.find(".introjs-nextbutton").text("Done!")

  previousStep: ->
    @changeStep(-1)

  nextStep: ->
    @changeStep(1)

  changeStep: (delta) ->
    $(".introjs-showElement").removeClass("introjs-showElement")
    return @endTour() unless @steps[@currentStep + delta]?
    @currentStep = @currentStep + delta
    @showCurrentStep()

  endTour: ->
    $(".introjs-showElement").removeClass("introjs-showElement")
    @$helperLayerDiv.popover('destroy')
    @$helperLayerDiv.remove()

    @$overlayDiv.fadeOut 100, ->
      $(@).remove()

    $(document).off "introjs"

(($) ->
  $.extend
    intro: (steps) ->
      new jQueryIntroJs(steps)
)(jQuery)
