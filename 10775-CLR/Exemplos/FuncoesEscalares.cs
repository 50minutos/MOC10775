using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Net;
using System.Linq;
using System.Net.Sockets;

public partial class FuncoesEscalares
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static int Random()
    {
        return new Random().Next(1, 11);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static String GetIpAddress()
    {
        return Dns.GetHostEntry(Dns.GetHostName())
            .AddressList.FirstOrDefault(GetIpAddress =>
                GetIpAddress.AddressFamily == AddressFamily.InterNetwork)
                .ToString();
    }
};

