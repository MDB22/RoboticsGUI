
public class MatlabComm {

  public MatlabProxy proxy;

  private MatlabProxyFactoryOptions options;
  private MatlabProxyFactory factory;

  public MatlabComm() throws MatlabConnectionException {
    options = new MatlabProxyFactoryOptions.Builder().setUsePreviouslyControlledSession(true).build();
    factory = new MatlabProxyFactory(options);
    proxy = factory.getProxy();
  }

  public void reconnect() throws MatlabConnectionException {
    proxy = factory.getProxy();
  }
}

