Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1610FAF4
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Dec 2019 10:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbfLCJoh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Dec 2019 04:44:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbfLCJoh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Dec 2019 04:44:37 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB39gHm3140052
        for <kvm-ppc@vger.kernel.org>; Tue, 3 Dec 2019 04:44:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wm6rrc8xy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 03 Dec 2019 04:44:35 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 3 Dec 2019 09:44:33 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Dec 2019 09:44:30 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB39iTJv47841338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Dec 2019 09:44:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 173314203F;
        Tue,  3 Dec 2019 09:44:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4EBE42045;
        Tue,  3 Dec 2019 09:44:26 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.39])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  3 Dec 2019 09:44:26 +0000 (GMT)
Date:   Tue, 3 Dec 2019 15:14:24 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Hugh Dickins <hughd@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v11 0/7] KVM: PPC: Driver to manage pages of secure guest
Reply-To: bharata@linux.ibm.com
References: <20191125030631.7716-1-bharata@linux.ibm.com>
 <20191128050411.GF23438@in.ibm.com>
 <alpine.LSU.2.11.1912011214180.1410@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1912011214180.1410@eggly.anvils>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19120309-0028-0000-0000-000003C3F85A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120309-0029-0000-0000-0000248710E9
Message-Id: <20191203094424.GA25855@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_01:2019-11-29,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912030079
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, Dec 01, 2019 at 12:24:50PM -0800, Hugh Dickins wrote:
> On Thu, 28 Nov 2019, Bharata B Rao wrote:
> > On Mon, Nov 25, 2019 at 08:36:24AM +0530, Bharata B Rao wrote:
> > > Hi,
> > > 
> > > This is the next version of the patchset that adds required support
> > > in the KVM hypervisor to run secure guests on PEF-enabled POWER platforms.
> > > 
> > 
> > Here is a fix for the issue Hugh identified with the usage of ksm_madvise()
> > in this patchset. It applies on top of this patchset.
> 
> It looks correct to me, and I hope will not spoil your performance in any
> way that matters.  But I have to say, the patch would be so much clearer,
> if you just named your bool "downgraded" instead of "downgrade".

Thanks for confirming. Yes "downgraded" would have been more
appropriate, will probably change it when we do any next change in this
part of the code.

Regards,
Bharata.

