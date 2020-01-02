Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3212F02E
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Jan 2020 23:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgABWvE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Jan 2020 17:51:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729186AbgABWYo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Jan 2020 17:24:44 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 002MLU9M127262
        for <kvm-ppc@vger.kernel.org>; Thu, 2 Jan 2020 17:24:42 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x6njcq29s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 02 Jan 2020 17:24:42 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Thu, 2 Jan 2020 22:24:40 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Jan 2020 22:24:38 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 002MObAA49152064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jan 2020 22:24:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B7A6A4053;
        Thu,  2 Jan 2020 22:24:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FBCCA4051;
        Thu,  2 Jan 2020 22:24:35 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.213.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jan 2020 22:24:35 +0000 (GMT)
Date:   Thu, 2 Jan 2020 14:24:32 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191216041924.42318-1-aik@ozlabs.ru>
 <20191216041924.42318-4-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216041924.42318-4-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20010222-4275-0000-0000-0000039433A2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010222-4276-0000-0000-000038A81745
Message-Id: <20200102222432.GC5556@oc0525413822.ibm.com>
Subject: Re:  [PATCH kernel v2 3/4] powerpc/pseries/iommu: Separate
 FW_FEATURE_MULTITCE to put/stuff features
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-02_07:2020-01-02,2020-01-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 spamscore=0 suspectscore=18 mlxscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001020181
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Dec 16, 2019 at 03:19:23PM +1100, Alexey Kardashevskiy wrote:
> H_PUT_TCE_INDIRECT allows packing up to 512 TCE updates into a single
> hypercall; H_STUFF_TCE can clear lots in a single hypercall too.
> 
> However, unlike H_STUFF_TCE (which writes the same TCE to all entries),
> H_PUT_TCE_INDIRECT uses a 4K page with new TCEs. In a secure VM
> environment this means sharing a secure VM page with a hypervisor which
> we would rather avoid.
> 
> This splits the FW_FEATURE_MULTITCE feature into FW_FEATURE_PUT_TCE_IND

Can FW_FEATURE_PUT_TCE_IND be made FW_FEATURE_PUT_TCE_INDIRECT?
It conveys the meaning a bit better than FW_FEATURE_PUT_TCE_IND.

This patch is a good optimization. 

Reviewed-by: Ram Pai <linuxram@us.ibm.com>

Thanks,
RP
> -- 

snip..

> 2.17.1

-- 
Ram Pai

