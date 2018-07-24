var SubscriptionForm = createReactClass({
  propTypes: {
    product: PropTypes.integer,
    shipping: {
      client_name: PropTypes.string,
      client_address: PropTypes.string,
      client_zip_code: PropTypes.string
    },
    billing: {
      card_number: PropTypes.string,
      exp_month: PropTypes.string,
      exp_year: PropTypes.string,
      cvv: PropTypes.string,
      zip_code: PropTypes.string
    }
  },
  getInitialState: function () {
    return {
      product: 1,
      shipping: {
        client_name: '',
        client_address: '',
        client_zip_code: ''
      },
      billing: {
        card_number: '',
        exp_month: '',
        exp_year: '',
        cvv: '',
        zip_code: ''
      }
    }
  },
  createSubscription: function (e) {
    e.preventDefault();
    var self = this;
    if (this.validForm()) {
      $.ajax({
        url: '/api/subscriptions',
        method: 'POST',
        data: { event: self.state },
        success: function (data) {
          self.props.createSubscription(data);
          self.setState(self.getInitialState());
        },
        error: function (xhr, status, error) {
          alert('Cannot process request: ', error);
        }
      });
    } else {
      alert('There were some errors on form.');
    }
  },
  validForm: function () {
    return (
      this.state.shipping.client_name && this.state.shipping.client_address &&
      this.state.shipping.client_zip_code && this.state.billing.card_number &&
      this.state.billing.exp_month && this.state.billing.exp_year &&
      this.state.billing.cvv && this.state.billing.zip_code
    );
  },
  handleChange: function (e) {
    var inputName = e.target.name;
    var value = e.target.value;
    var newState = this.state;
    newState[inputName] = value;
    this.setState(newState);
  },
  render: function () {
    return (
      <form className="form-inline" onSubmit={this.createSubscription}>
        <div className="form-group">
          <select type="text"
                 className="form-control"
                 name="product"
                 ref="product"
                 value={this.state.product}
                 onChange={this.handleChange}>
            <option value="1">Bronze Box (19.99 $)</option>
            <option value="2">Silver Box (49.00 $)</option>
            <option value="3">Gold Box (99.00 $)</option>
          </select>
        </div>
        <div className="form-group">
          <input type="text"
                 className="form-control"
                 name="shipping.client_name"
                 placeholder="Full Name"
                 ref="shipping.client_name"
                 value={this.state.shipping.client_name}
                 onChange={this.handleChange} />
        </div>
        <div className="form-group">
          <input type="date"
                 className="form-control"
                 name="shipping.client_address"
                 placeholder="Address"
                 ref="shipping.client_address"
                 value={this.state.shipping.client_address}
                 onChange={this.handleChange} />
        </div>
        <div className="form-group">
          <input type="text"
                 className="form-control"
                 name="shipping.client_zip_code"
                 placeholder="Zip Code"
                 ref="shipping.client_address"
                 value={this.state.shipping.client_address}
                 onChange={this.handleChange} />
        </div>
        <button type="submit" className="btn btn-primary">Subscribe!</button>
</form>
    );
  }
});
