using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Windows;
using Microsoft.Shell;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    /// <summary>
    /// App.xaml 的交互逻辑
    /// </summary>
    public partial class App : Application, ISingleInstanceApp
    {
        private const string _uniq = "Brilliantech_Warehouse_LED_Service";
        [STAThread]
        public static void Main()
        {
            if (SingleInstance<App>.InitializeAsFirstInstance(_uniq))
            {
                App app = new App();
                app.InitializeComponent();
                app.Run();
                SingleInstance<App>.Cleanup();
            }
        }

        public bool SignalExternalCommandLineArgs(IList<string> args)
        {
            return true;
        }
    }
}
