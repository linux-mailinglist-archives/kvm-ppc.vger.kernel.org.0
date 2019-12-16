Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81472121EA9
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 23:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLPW7Z (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Dec 2019 17:59:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726561AbfLPW7Y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Dec 2019 17:59:24 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGMv0r3008018;
        Mon, 16 Dec 2019 17:59:05 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wwdtad3cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 17:59:05 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBGMpIxa008040;
        Mon, 16 Dec 2019 22:59:04 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 2wvqc6cw8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 22:59:04 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBGMx3W926083800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 22:59:03 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50586AE060;
        Mon, 16 Dec 2019 22:59:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 492B7AE062;
        Mon, 16 Dec 2019 22:58:58 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.177.201])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 16 Dec 2019 22:58:56 +0000 (GMT)
References: <20191216041924.42318-1-aik@ozlabs.ru> <20191216041924.42318-2-aik@ozlabs.ru>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH kernel v2 1/4] Revert "powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests"
In-reply-to: <20191216041924.42318-2-aik@ozlabs.ru>
Date:   Mon, 16 Dec 2019 19:58:45 -0300
Message-ID: <87a77rubbu.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=657
 phishscore=0 spamscore=0 clxscore=1011 suspectscore=18 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160192
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Hello Alexey,

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> From: Ram Pai <linuxram@us.ibm.com>
>
> This reverts commit edea902c1c1efb855f77e041f9daf1abe7a9768a.
>
> At the time the change allowed direct DMA ops for secure VMs; however
> since then we switched on using SWIOTLB backed with IOMMU (direct mapping)
> and to make this work, we need dma_iommu_ops which handles all cases
> including TCE mapping I/O pages in the presence of an IOMMU.
>
> Fixes: edea902c1c1e ("powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests")
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [aik: added "revert" and "fixes:"]
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
