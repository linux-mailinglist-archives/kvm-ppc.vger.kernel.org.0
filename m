Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA1C20C8EB
	for <lists+kvm-ppc@lfdr.de>; Sun, 28 Jun 2020 18:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgF1QMN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 28 Jun 2020 12:12:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbgF1QMM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 28 Jun 2020 12:12:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05SG39VW175324;
        Sun, 28 Jun 2020 12:11:59 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31x2m7xatx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jun 2020 12:11:59 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05SG7eIj031558;
        Sun, 28 Jun 2020 16:11:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 31wwr88net-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jun 2020 16:11:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05SGBrks35586218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Jun 2020 16:11:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0528A4053;
        Sun, 28 Jun 2020 16:11:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA88BA4040;
        Sun, 28 Jun 2020 16:11:51 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.74.221])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 28 Jun 2020 16:11:51 +0000 (GMT)
Date:   Sun, 28 Jun 2020 21:41:49 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH v3 0/4] Migrate non-migrated pages of a SVM.
Message-ID: <20200628161149.GA27215@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <1592606622-29884-1-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592606622-29884-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=1 mlxlogscore=943
 phishscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 cotscore=-2147483648 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280120
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jun 19, 2020 at 03:43:38PM -0700, Ram Pai wrote:
> The time taken to switch a VM to Secure-VM, increases by the size of the VM.  A
> 100GB VM takes about 7minutes. This is unacceptable.  This linear increase is
> caused by a suboptimal behavior by the Ultravisor and the Hypervisor.  The
> Ultravisor unnecessarily migrates all the GFN of the VM from normal-memory to
> secure-memory. It has to just migrate the necessary and sufficient GFNs.
> 
> However when the optimization is incorporated in the Ultravisor, the Hypervisor
> starts misbehaving. The Hypervisor has a inbuilt assumption that the Ultravisor
> will explicitly request to migrate, each and every GFN of the VM. If only
> necessary and sufficient GFNs are requested for migration, the Hypervisor
> continues to manage the remaining GFNs as normal GFNs. This leads of memory
> corruption, manifested consistently when the SVM reboots.
> 
> The same is true, when a memory slot is hotplugged into a SVM. The Hypervisor
> expects the ultravisor to request migration of all GFNs to secure-GFN.  But at
> the same time, the hypervisor is unable to handle any H_SVM_PAGE_IN requests
> from the Ultravisor, done in the context of UV_REGISTER_MEM_SLOT ucall.  This
> problem manifests as random errors in the SVM, when a memory-slot is
> hotplugged.
> 
> This patch series automatically migrates the non-migrated pages of a SVM,
>      and thus solves the problem.

So this is what I understand as the objective of this patchset:

1. Getting all the pages into the secure memory right when the guest
   transitions into secure mode is expensive. Ultravisor wants to just get
   the necessary and sufficient pages in and put the onus on the Hypervisor
   to mark the remaining pages (w/o actual page-in) as secure during
   H_SVM_INIT_DONE.
2. During H_SVM_INIT_DONE, you want a way to differentiate the pages that
   are already secure from the pages that are shared and that are paged-out.
   For this you are introducing all these new states in HV.

UV knows about the shared GFNs and maintains the state of the same. Hence
let HV send all the pages (minus already secured pages) via H_SVM_PAGE_IN
and if UV finds any shared pages in them, let it fail the uv-page-in call.
Then HV can fail the migration for it  and the page continues to remain
shared. With this, you don't need to maintain a state for secured GFN in HV.

In the unlikely case of sending a paged-out page to UV during
H_SVM_INIT_DONE, let the page-in succeed and HV will fault on it again
if required. With this, you don't need a state in HV to identify a
paged-out-but-encrypted state.

Doesn't the above work? If so, we can avoid all those extra states
in HV. That way HV can continue to differentiate only between two types
of pages: secure and not-secure. The rest of the states (shared,
paged-out-encrypted) actually belong to SVM/UV and let UV take care of
them.

Or did I miss something?

Regards,
Bharata.
