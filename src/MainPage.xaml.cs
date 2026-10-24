using System;
using Windows.System;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;

namespace WPMobileBrowser
{
    public sealed partial class MainPage : Page
    {
        private const string HomeUrl = "https://www.bing.com/";

        public MainPage()
        {
            this.InitializeComponent();
            Navigate(HomeUrl);
        }

        private void Navigate(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw)) return;
            string url = raw.Trim();
            if (!url.StartsWith("http://", StringComparison.OrdinalIgnoreCase) &&
                !url.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                url = "https://" + url;
            try
            {
                Web.Navigate(new Uri(url));
                UrlBox.Text = url;
            }
            catch
            {
                UrlBox.Text = "alamat tidak valid";
            }
        }

        private void BtnGo_Click(object sender, RoutedEventArgs e) => Navigate(UrlBox.Text);

        private void UrlBox_KeyDown(object sender, KeyRoutedEventArgs e)
        {
            if (e.Key == VirtualKey.Enter)
            {
                Navigate(UrlBox.Text);
                e.Handled = true;
            }
        }

        private void BtnBack_Click(object sender, RoutedEventArgs e)
        {
            if (Web.CanGoBack) Web.GoBack();
        }

        private void BtnForward_Click(object sender, RoutedEventArgs e)
        {
            if (Web.CanGoForward) Web.GoForward();
        }

        private void BtnHome_Click(object sender, RoutedEventArgs e) => Navigate(HomeUrl);

        private void Web_NavigationStarted(WebView sender, WebViewNavigationStartedEventArgs args)
        {
            Bar.Visibility = Visibility.Visible;
            UrlBox.Text = args.Uri.ToString();
        }

        private void Web_NavigationCompleted(WebView sender, WebViewNavigationCompletedEventArgs args)
        {
            Bar.Visibility = Visibility.Collapsed;
        }
    }
}
