Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8651C121EEB
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 00:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLPXYq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Dec 2019 18:24:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbfLPXYq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Dec 2019 18:24:46 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGNN0jC105337;
        Mon, 16 Dec 2019 18:24:34 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wwdpyy9bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 18:24:34 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBGNN1jb006981;
        Mon, 16 Dec 2019 23:24:32 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2wvqc5y9d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 23:24:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBGNOVOn55378406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 23:24:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7952C6057;
        Mon, 16 Dec 2019 23:24:31 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4F3CC6055;
        Mon, 16 Dec 2019 23:24:12 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.177.201])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 16 Dec 2019 23:24:11 +0000 (GMT)
References: <20191216041924.42318-1-aik@ozlabs.ru> <20191216041924.42318-5-aik@ozlabs.ru>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH kernel v2 4/4] powerpc/pseries/svm: Allow IOMMU to work in SVM
In-reply-to: <20191216041924.42318-5-aik@ozlabs.ru>
Date:   Mon, 16 Dec 2019 20:23:55 -0300
Message-ID: <875zifua5w.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=18 lowpriorityscore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=784 malwarescore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160196
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> H_PUT_TCE_INDIRECT uses a shared page to send up to 512 TCE to
> a hypervisor in a single hypercall. This does not work for secure VMs
> as the page needs to be shared or the VM should use H_PUT_TCE instead.
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

Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
