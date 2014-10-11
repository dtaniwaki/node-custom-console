chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
expect = chai.expect
chai.use(sinonChai)

OriginalConsole = require('console').Console
Console = new OriginalConsole({write: -> }, {write: -> })

utilsConsole = require '../lib/console'

describe 'console', ->
  beforeEach ->
    @sandbox = sinon.sandbox.create()
    process.env.NODE_DEBUG ||= ''

  afterEach ->
    @sandbox.restore()

  describe 'log functions', ->
    for _name in ['log', 'info', 'warn', 'error']
      describe "\##{_name}", ->
        name = _name
        beforeEach ->
          @now = new Date('2014-10-02T06:15:16.830Z')
          @sandbox.useFakeTimers(@now.valueOf())
          @sandbox.stub process.env, 'NODE_DEBUG', 'chai'

        describe "normal case", ->
          beforeEach ->
            @spy = @sandbox.spy Console, name
            @console = utilsConsole('chai', console: Console)

          it "writes the #{name} messages", ->
            @console[name] 'foo', 'bar'
            expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [#{name}] #{process.pid} chai:", 'foo', 'bar')

        describe "output condition", ->
          beforeEach ->
            @spy = @sandbox.spy Console, name

          describe "NODE_DEBUG = 'x'", ->
            beforeEach ->
              @sandbox.stub process.env, 'NODE_DEBUG', 'x'
              @console = utilsConsole('x', console: Console)

            it "writes the #{name} messages", ->
              @console[name] 'foo', 'bar'
              expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [#{name}] #{process.pid} x:", 'foo', 'bar')

          describe "NODE_DEBUG = '*'", ->
            beforeEach ->
              @sandbox.stub process.env, 'NODE_DEBUG', '*'
              @console = utilsConsole('x', console: Console)

            it "writes the #{name} messages", ->
              @console[name] 'foo', 'bar'
              expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [#{name}] #{process.pid} x:", 'foo', 'bar')

          describe "NODE_DEBUG = 'other'", ->
            beforeEach ->
              @sandbox.stub process.env, 'NODE_DEBUG', 'other'
              @console = utilsConsole('x', console: Console)

            it "does not write the #{name} messages", ->
              @console[name] 'foo', 'bar'
              expect(@spy).to.have.been.callCount(0)

    describe "debug level", ->
      beforeEach ->
        @now = new Date('2014-10-02T06:15:16.830Z')
        @sandbox.useFakeTimers(@now.valueOf())

      describe "specific level", ->
        beforeEach ->
          @sandbox.stub process.env, 'NODE_DEBUG', 'x:info'
          @console = utilsConsole('x', console: Console)

        it "writes the error messages", ->
          @spy = @sandbox.spy Console, 'error'
          @console.error 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [error] #{process.pid} x:", 'foo', 'bar')

        it "writes the warn messages", ->
          @spy = @sandbox.spy Console, 'warn'
          @console.warn 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [warn] #{process.pid} x:", 'foo', 'bar')

        it "writes the info messages", ->
          @spy = @sandbox.spy Console, 'info'
          @console.info 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [info] #{process.pid} x:", 'foo', 'bar')

        it "writes the log messages", ->
          @spy = @sandbox.spy Console, 'log'
          @console.log 'foo', 'bar'
          expect(@spy).to.have.been.callCount(0)

      describe "any level", ->
        beforeEach ->
          @sandbox.stub process.env, 'NODE_DEBUG', 'x'
          @console = utilsConsole('x', console: Console)

        it "writes the error messages", ->
          @spy = @sandbox.spy Console, 'error'
          @console.error 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [error] #{process.pid} x:", 'foo', 'bar')

        it "writes the warn messages", ->
          @spy = @sandbox.spy Console, 'warn'
          @console.warn 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [warn] #{process.pid} x:", 'foo', 'bar')

        it "writes the info messages", ->
          @spy = @sandbox.spy Console, 'info'
          @console.info 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [info] #{process.pid} x:", 'foo', 'bar')

        it "writes the log messages", ->
          @spy = @sandbox.spy Console, 'log'
          @console.log 'foo', 'bar'
          expect(@spy).to.have.been.calledWith("2014-10-02T06:15:16.830Z [log] #{process.pid} x:", 'foo', 'bar')

  describe "delegate functions", ->
    for _name in ['trace', 'time', 'timeEnd', 'assert', 'dir']
      describe "\##{_name}", ->
        name = _name
        beforeEach ->
          @spy = @sandbox.spy Console, name
          @console = utilsConsole('chai', console: Console)

        it "delegates the #{name} call", ->
          @console[name] 'foo', 'bar'
          expect(@spy).to.have.been.calledWith('foo', 'bar')

  describe "\#init", ->
    beforeEach ->
      @sandbox.stub process.env, 'NODE_DEBUG', 'chai'
      @console = utilsConsole('chai', console: Console)

    it 'initializes the debug settings', ->
      expect(@console.enabled).to.be.eq true
      expect(@console.level).to.be.eq 0

    describe 'debug target change', ->
      beforeEach ->
        @sandbox.stub process.env, 'NODE_DEBUG', 'foo'

      it 'reinitializes the debug settings', ->
        expect(@console.enabled).to.be.eq true
        expect(@console.level).to.be.eq 0

        @console.init()
        expect(@console.enabled).to.be.eq false
        expect(@console.level).to.be.eq 0

    describe 'debug level change', ->
      beforeEach ->
        @sandbox.stub process.env, 'NODE_DEBUG', 'chai:log'

      it 'reinitializes the debug settings', ->
        expect(@console.enabled).to.be.eq true
        expect(@console.level).to.be.eq 0

        @console.init()
        expect(@console.enabled).to.be.eq true
        expect(@console.level).to.be.eq 1

  describe "\#prefix", ->
    beforeEach ->
      @spy = @sandbox.spy()
      @console = utilsConsole('chai', console: Console, prefix: @spy)

    it "uses user defined prefix", ->
      @console.info 'foo', 'bar'
      expect(@spy).to.have.been.calledWith('chai', 'info')

  describe "\#postfix", ->
    beforeEach ->
      @spy = @sandbox.spy()
      @console = utilsConsole('chai', console: Console, postfix: @spy)

    it "uses user defined postfix", ->
      @console.info 'foo', 'bar'
      expect(@spy).to.have.been.calledWith('chai', 'info')
