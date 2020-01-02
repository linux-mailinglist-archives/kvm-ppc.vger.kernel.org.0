Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12712F091
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Jan 2020 23:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgABWxn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Jan 2020 17:53:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729003AbgABWVd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Jan 2020 17:21:33 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 002MLVRe164642
        for <kvm-ppc@vger.kernel.org>; Thu, 2 Jan 2020 17:21:31 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2x87mrdcd3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 02 Jan 2020 17:21:31 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Thu, 2 Jan 2020 22:21:16 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Jan 2020 22:21:14 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 002MLCHD39977162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jan 2020 22:21:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82D8FAE045;
        Thu,  2 Jan 2020 22:21:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46414AE053;
        Thu,  2 Jan 2020 22:21:10 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.213.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jan 2020 22:21:10 +0000 (GMT)
Date:   Thu, 2 Jan 2020 14:21:06 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191216041924.42318-1-aik@ozlabs.ru>
 <20191216041924.42318-5-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216041924.42318-5-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20010222-4275-0000-0000-000003943383
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010222-4276-0000-0000-000038A81725
Message-Id: <20200102222106.GB5556@oc0525413822.ibm.com>
Subject: Re:  [PATCH kernel v2 4/4] powerpc/pseries/svm: Allow IOMMU to work in SVM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-02_07:2020-01-02,2020-01-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 suspectscore=18 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001020181
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Dec 16, 2019 at 03:19:24PM +1100, Alexey Kardashevskiy wrote:
> H_PUT_TCE_INDIRECT uses a shared page to send up to 512 TCE to
> a hypervisor in a single hypercall.

Actually H_PUT_TCE_INDIRECT never used shared page.  It would have
used shared pages if the 'shared-page' solution was accepted. :)



> This does not work for secure VMs
> as the page needs to be shared or the VM should use H_PUT_TCE instead.

Maybe you should say something like this.. ?

H_PUT_TCE_INDIRECT does not work for secure VMs, since the page
containing the TCE entries is not accessible to the hypervisor.

> 
> This disables H_PUT_TCE_INDIRECT by clearing the FW_FEATURE_PUT_TCE_IND
> feature bit so SVMs will map TCEs using H_PUT_TCE.
> 
> This is not a part of init_svm() as it is called too late after FW
> patching is done and may result in a warning like this:
> 
> [    3.727716] Firmware features changed after feature patching!
> [    3.727965] WARNING: CPU: 0 PID: 1 at (...)arch/powerpc/lib/feature-fixups.c:466 check_features+0xa4/0xc0
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>


Reviewed-by: Ram Pai <linuxram@us.ibm.com>


> ---
> Changes:
> v2
> * new in the patchset
> ---
>  arch/powerpc/platforms/pseries/firmware.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
> index d3acff23f2e3..3e49cc23a97a 100644
> --- a/arch/powerpc/platforms/pseries/firmware.c
> +++ b/arch/powerpc/platforms/pseries/firmware.c
> @@ -22,6 +22,7 @@
>  #include <asm/firmware.h>
>  #include <asm/prom.h>
>  #include <asm/udbg.h>
> +#include <asm/svm.h>
> 
>  #include "pseries.h"
> 
> @@ -101,6 +102,12 @@ static void __init fw_hypertas_feature_init(const char *hypertas,
>  		}
>  	}
> 
> +	if (is_secure_guest() &&
> +	    (powerpc_firmware_features & FW_FEATURE_PUT_TCE_IND)) {
> +		powerpc_firmware_features &= ~FW_FEATURE_PUT_TCE_IND;
> +		pr_debug("SVM: disabling PUT_TCE_IND firmware feature\n");
> +	}
> +
>  	pr_debug(" <- fw_hypertas_feature_init()\n");
>  }
> 
> -- 
> 2.17.1

-- 
Ram Pai

