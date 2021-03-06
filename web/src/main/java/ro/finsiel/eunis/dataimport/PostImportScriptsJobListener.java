package ro.finsiel.eunis.dataimport;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobListener;

import ro.finsiel.eunis.utilities.SQLUtilities;


/**
 *
 * @author altnyris
 *
 */
public class PostImportScriptsJobListener implements JobListener {

    /** */
    private static Log logger = LogFactory.getLog(
            PostImportScriptsJobListener.class);

    /*
     * (non-Javadoc)
     * @see org.quartz.JobListener#getName()
     */
    public String getName() {
        return this.getClass().getSimpleName();
    }

    /*
     * (non-Javadoc)
     * @see org.quartz.JobListener#jobExecutionVetoed(org.quartz.JobExecutionContext)
     */
    public void jobExecutionVetoed(JobExecutionContext context) {
        logger.info(
                "Execution vetoed for job " + context.getJobDetail().getName());
    }

    /*
     * (non-Javadoc)
     * @see org.quartz.JobListener#jobToBeExecuted(org.quartz.JobExecutionContext)
     */
    public void jobToBeExecuted(JobExecutionContext context) {
        JobDataMap dataMap = context.getJobDetail().getJobDataMap();

        String sqlDrv = dataMap.getString("sqlDrv");
        String sqlUrl = dataMap.getString("sqlUrl");
        String sqlUsr = dataMap.getString("sqlUsr");
        String sqlPwd = dataMap.getString("sqlPwd");

        SQLUtilities sql = new SQLUtilities();

        sql.Init();

        sql.addImportLogMessage("Post import scripts started!");
    }

    /*
     * (non-Javadoc)
     * @see org.quartz.JobListener#jobWasExecuted(org.quartz.JobExecutionContext, org.quartz.JobExecutionException)
     */
    public void jobWasExecuted(JobExecutionContext context, JobExecutionException exception) {

        JobDataMap dataMap = context.getJobDetail().getJobDataMap();

        String sqlDrv = dataMap.getString("sqlDrv");
        String sqlUrl = dataMap.getString("sqlUrl");
        String sqlUsr = dataMap.getString("sqlUsr");
        String sqlPwd = dataMap.getString("sqlPwd");

        SQLUtilities sql = new SQLUtilities();

        sql.Init();

        if (exception != null) {
            logger.error(
                    "Exception thrown when executing job "
                            + context.getJobDetail().getName() + ": "
                            + exception.toString(),
                            exception);
            sql.addImportLogMessage("Post import scripts failed!");
            return;
        } else {
            sql.addImportLogMessage("Post import scripts successfully finished!");
        }
    }
}
