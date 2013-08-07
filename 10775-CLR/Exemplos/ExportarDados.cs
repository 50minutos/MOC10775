using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void ExportarDados(String cmd, String nomeArquivo)
    {
        using (var c = new SqlConnection("Context Connection=true;"))
        {
            using (var da = new SqlDataAdapter(cmd, c))
            {
                var dt = new DataTable("OUTPUT");

                da.Fill(dt);

                dt.WriteXml(nomeArquivo);
            }
        }
    }
};
