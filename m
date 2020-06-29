Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912CD20DE21
	for <lists+kvm-ppc@lfdr.de>; Mon, 29 Jun 2020 23:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgF2UWz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 29 Jun 2020 16:22:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732576AbgF2TZc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 29 Jun 2020 15:25:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TJ3Xeg043662;
        Mon, 29 Jun 2020 15:25:21 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31x1rv25u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 15:25:21 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05TJJpVY014429;
        Mon, 29 Jun 2020 19:25:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 31wwr899kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 19:25:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05TJPGgg11010472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 19:25:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F198C42041;
        Mon, 29 Jun 2020 19:25:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29F4042047;
        Mon, 29 Jun 2020 19:25:13 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.34.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Jun 2020 19:25:12 +0000 (GMT)
Date:   Mon, 29 Jun 2020 12:25:10 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH v3 0/4] Migrate non-migrated pages of a SVM.
Message-ID: <20200629192510.GD6772@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1592606622-29884-1-git-send-email-linuxram@us.ibm.com>
 <20200628161149.GA27215@in.ibm.com>
 <20200629015330.GC27215@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629015330.GC27215@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 cotscore=-2147483648 lowpriorityscore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290120
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jun 29, 2020 at 07:23:30AM +0530, Bharata B Rao wrote:
> On Sun, Jun 28, 2020 at 09:41:53PM +0530, Bharata B Rao wrote:
> > On Fri, Jun 19, 2020 at 03:43:38PM -0700, Ram Pai wrote:
> > > The time taken to switch a VM to Secure-VM, increases by the size of the VM.  A
> > > 100GB VM takes about 7minutes. This is unacceptable.  This linear increase is
> > > caused by a suboptimal behavior by the Ultravisor and the Hypervisor.  The
> > > Ultravisor unnecessarily migrates all the GFN of the VM from normal-memory to
> > > secure-memory. It has to just migrate the necessary and sufficient GFNs.
> > > 
> > > However when the optimization is incorporated in the Ultravisor, the Hypervisor
> > > starts misbehaving. The Hypervisor has a inbuilt assumption that the Ultravisor
> > > will explicitly request to migrate, each and every GFN of the VM. If only
> > > necessary and sufficient GFNs are requested for migration, the Hypervisor
> > > continues to manage the remaining GFNs as normal GFNs. This leads of memory
> > > corruption, manifested consistently when the SVM reboots.
> > > 
> > > The same is true, when a memory slot is hotplugged into a SVM. The Hypervisor
> > > expects the ultravisor to request migration of all GFNs to secure-GFN.  But at
> > > the same time, the hypervisor is unable to handle any H_SVM_PAGE_IN requests
> > > from the Ultravisor, done in the context of UV_REGISTER_MEM_SLOT ucall.  This
> > > problem manifests as random errors in the SVM, when a memory-slot is
> > > hotplugged.
> > > 
> > > This patch series automatically migrates the non-migrated pages of a SVM,
> > >      and thus solves the problem.
> > 
> > So this is what I understand as the objective of this patchset:
> > 
> > 1. Getting all the pages into the secure memory right when the guest
> >    transitions into secure mode is expensive. Ultravisor wants to just get
> >    the necessary and sufficient pages in and put the onus on the Hypervisor
> >    to mark the remaining pages (w/o actual page-in) as secure during
> >    H_SVM_INIT_DONE.
> > 2. During H_SVM_INIT_DONE, you want a way to differentiate the pages that
> >    are already secure from the pages that are shared and that are paged-out.
> >    For this you are introducing all these new states in HV.
> > 
> > UV knows about the shared GFNs and maintains the state of the same. Hence
> > let HV send all the pages (minus already secured pages) via H_SVM_PAGE_IN
> > and if UV finds any shared pages in them, let it fail the uv-page-in call.
> > Then HV can fail the migration for it  and the page continues to remain
> > shared. With this, you don't need to maintain a state for secured GFN in HV.
> > 
> > In the unlikely case of sending a paged-out page to UV during
> > H_SVM_INIT_DONE, let the page-in succeed and HV will fault on it again
> > if required. With this, you don't need a state in HV to identify a
> > paged-out-but-encrypted state.
> > 
> > Doesn't the above work?
> 
> I see that you want to infact skip the uv-page-in calls from H_SVM_INIT_DONE.
> So that would need the extra states in HV which you are proposing here.

Yes. I want to skip to speed up the overall ESM switch.

RP
