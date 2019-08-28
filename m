Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4203E9FE85
	for <lists+kvm-ppc@lfdr.de>; Wed, 28 Aug 2019 11:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfH1Jc7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 28 Aug 2019 05:32:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726270AbfH1Jc7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 28 Aug 2019 05:32:59 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7S9N2mk054638
        for <kvm-ppc@vger.kernel.org>; Wed, 28 Aug 2019 05:32:57 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2unm7bprvp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 28 Aug 2019 05:32:57 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <svaidy@linux.ibm.com>;
        Wed, 28 Aug 2019 10:22:20 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 28 Aug 2019 10:22:18 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7S9LtUb22151504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 09:21:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 337ACA4051;
        Wed, 28 Aug 2019 09:22:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9292A404D;
        Wed, 28 Aug 2019 09:22:14 +0000 (GMT)
Received: from drishya.in.ibm.com (unknown [9.109.202.191])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 28 Aug 2019 09:22:14 +0000 (GMT)
Date:   Wed, 28 Aug 2019 14:52:08 +0530
From:   Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Ryan Grimm <grimm@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
Subject: Re: [PATCH v2] powerpc/powernv: Add ultravisor message log interface
Reply-To: svaidy@linux.ibm.com
References: <20190823060654.28842-1-cclaudio@linux.ibm.com>
 <87o90g3v5o.fsf@concordia.ellerman.id.au>
 <4e577a36-4ce1-410b-3ceb-d31bbf564b3d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4e577a36-4ce1-410b-3ceb-d31bbf564b3d@linux.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19082809-0028-0000-0000-00000394D2D2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082809-0029-0000-0000-000024570E70
Message-Id: <20190828092208.GA26104@drishya.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-28_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908280099
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

* Claudio Carvalho <cclaudio@linux.ibm.com> [2019-08-24 23:19:19]:

> 
> On 8/23/19 9:48 AM, Michael Ellerman wrote:
> > Hi Claudio,
> 
> Hi Michael,
> 
> >
> > Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> >> Ultravisor (UV) provides an in-memory console which follows the OPAL
> >> in-memory console structure.
> >>
> >> This patch extends the OPAL msglog code to also initialize the UV memory
> >> console and provide a sysfs interface (uv_msglog) for userspace to view
> >> the UV message log.
> >>
> >> CC: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> >> CC: Oliver O'Halloran <oohall@gmail.com>
> >> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> >> ---
> >> This patch depends on the "kvmppc: Paravirtualize KVM to support
> >> ultravisor" patchset submitted by Claudio Carvalho.
> >> ---
> >>  arch/powerpc/platforms/powernv/opal-msglog.c | 99 ++++++++++++++------
> >>  1 file changed, 72 insertions(+), 27 deletions(-)
> > I think the code changes look mostly OK here.
> >
> > But I'm not sure about the end result in sysfs.
> >
> > If I'm reading it right this will create:
> >
> >  /sys/firmware/opal/uv_msglog
> >
> > Which I think is a little weird, because the UV is not OPAL.
> >
> > So I guess I wonder if the file should be created elsewhere to avoid any
> > confusion and keep things nicely separated.
> >
> > Possibly /sys/firmware/ultravisor/msglog ?
> 
> 
> Yes, makes sense. I will do that.

+1

Letting the UV have its own /sys/firmware/ultravisor/xxx is a good
idea. We may have a need to export more runtime data from UV for
debug/profile purposes and this sysfs directory will come handy.

--Vaidy

