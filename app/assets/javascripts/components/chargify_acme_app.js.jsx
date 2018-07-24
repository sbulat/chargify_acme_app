var ChargifyAcmeApp = createReactClass({
  render: function () {
    return (
      <div className="container">
        <div className="jumbotron">
          <h1>Acme Online</h1>
        </div>
        <div className="row">
          <div className="col-md-12">
            <SubscriptionForm />
          </div>
        </div>
      </div>
    )
  }
});
