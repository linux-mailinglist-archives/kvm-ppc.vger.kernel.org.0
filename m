Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3522343E2
	for <lists+kvm-ppc@lfdr.de>; Fri, 31 Jul 2020 12:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbgGaKDC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 31 Jul 2020 06:03:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732371AbgGaKDB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 31 Jul 2020 06:03:01 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VA28wW083706;
        Fri, 31 Jul 2020 06:02:52 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mfb8k32h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 06:02:51 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V9ucCr011895;
        Fri, 31 Jul 2020 10:02:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 32gcqgq3uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 10:02:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06VA2j6Y28574140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 10:02:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60E014C058;
        Fri, 31 Jul 2020 10:02:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 208664C040;
        Fri, 31 Jul 2020 10:02:43 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.52.65])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jul 2020 10:02:42 +0000 (GMT)
Date:   Fri, 31 Jul 2020 15:32:40 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH] KVM: PPC: Book3S HV: fix a oops in
 kvmppc_uvmem_page_free()
Message-ID: <20200731100240.GC20199@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <1596151526-4374-1-git-send-email-linuxram@us.ibm.com>
 <20200731042940.GA20199@in.ibm.com>
 <20200731083700.GB5787@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731083700.GB5787@oc0525413822.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_03:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310071
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 31, 2020 at 01:37:00AM -0700, Ram Pai wrote:
> On Fri, Jul 31, 2020 at 09:59:40AM +0530, Bharata B Rao wrote:
> > On Thu, Jul 30, 2020 at 04:25:26PM -0700, Ram Pai wrote:
> > In our case, device pages that are in use are always associated with a valid
> > pvt member. See kvmppc_uvmem_get_page() which returns failure if it
> > runs out of device pfns and that will result in proper failure of
> > page-in calls.
> 
> looked at the code, and yes that code path looks correct. So my
> reasoning behind the root cause of this bug is incorrect. However the
> bug is surfacing and there must be a reason.
> 
> > 
> > For the case where we run out of device pfns, migrate_vma_finalize() will
> > restore the original PTE and will not replace the PTE with device private PTE.
> > 
> > Also kvmppc_uvmem_page_free() (=dev_pagemap_ops.page_free()) is never
> > called for non-device-private pages.
> 
> Yes. it should not be called. But as seen above in the stack trace, it is called. 
> 
> What would cause the HMM to call ->page_free() on a page that is not
> associated with that device's pfn?

I believe it is being called for a device private page, you can verify
it when you hit it next time?

> 
> > 
> > This could be a use-after-free case possibly arising out of the new state
> > changes in HV. If so, this fix will only mask the bug and not address the
> > original problem.
> 
> I can verify by rerunning the tests, without the new state changes. But
> I do not see how those changes can cause this fault?
> 
> This could also be caused by a duplicate ->page_free() call due to some
> bug in the migrate_page path? Could there be a race between
> migrate_page() and a page_fault ?
> 
> 
> Regardless, kvmppc_uvmem_page_free() needs to be fixed. It should not
> access contents of pvt, without verifing pvt is valid.

We don't expect pvt to be NULL here. Checking for NULL and returning
isn't the right fix, I think.

Regards,
Bharata.
