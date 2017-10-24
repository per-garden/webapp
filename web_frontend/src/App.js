import React, { Component } from 'react'
import logo from './logo.svg'
import './App.css'
import config from './config'

const root_path = config.root_path
const login_path = '/login'
const hubs_path = '/hubs'
const logout_path = '/logout'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      login: '',
      password: '',
      hubs: [],
      loading: false,
      token: '',
    }
  }

  onChangeLogin(e) {
    this.setState({ login: e.target.value })
  }

  onChangePassword(e) {
    this.setState({ password: e.target.value })
  }

  login() {
    const that = this
    that.setState({ loading: true })
    that.load(
      'POST',
      root_path + login_path,
      {
        login: that.state.login,
        password: that.state.password,
      },
      function(login_res) {
        console.log('response from login:', login_res)
        that.setState({ token: login_res.api_token })
        that.load(
          'GET',
          root_path + hubs_path,
          {
            api_token: that.state.token,
          },
          function(res) {
            console.log('response from hubs:', res)

            that.setState({ hubs: res, loading: false })
          }
        )
      }
    )
  }

  load(method, url, headers, cb) {
    console.log('---------------')
    console.log(method, url)

    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if (xhr && xhr.readyState === 4) {

        if (xhr.status === 503) {
          console.log('ERR:', xhr.status)
        }

        if (xhr.status === 200) {
          //console.log('SUCCESS:', xhr.status, xhr.responseText);
        }
        console.log('run cb...' + xhr.readyState)
        cb(JSON.parse(xhr.responseText))
      }
    }

    xhr.open(method, url, true)

    for (var key in headers) {
      console.log('adding header => ', key + ' : ' + headers[key])
      xhr.setRequestHeader(key, headers[key])
    }
    xhr.send()
  }

  logout() {
    const that = this
    that.load(
      'GET',
      root_path + logout_path,
      {
        api_token: that.state.token,
      },
      function(logout_res) {
        console.log('response from logout:', logout_res)
        that.setState({ login: '', password: '', hubs: [], loading: false, token: '',})
      }
    )
  }

  componentWillMount() {}

  render() {
    const state = this.state
    const loading = state.loading
    const showLogin = state.token === null || state.token === ''
    return (
      <div className="App">
        <header className="App-header">
          {loading && <img src={logo} className="App-logo" alt="logo" />}
          { showLogin && (
              <div>
                <input onChange={this.onChangeLogin.bind(this)} value={state.login} />
                <input onChange={this.onChangePassword.bind(this)} value={state.password} />
                <button onClick={this.login.bind(this)}>LOGIN</button>
              </div>
            )
          }
          { !showLogin && (
              <div>
                <button onClick={this.logout.bind(this)}>LOGOUT</button>
              </div>
            )
          }
        </header>{' '}
        { !showLogin && (
          <div>
            {this.state.hubs.map((hub, i) => {
              return <p key={i}> {hub.name + ': ' + hub.id}</p>
            })}
          </div>
        )}
      </div>
    )
  }
}

export default App
