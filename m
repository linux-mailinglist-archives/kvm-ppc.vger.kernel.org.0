Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64268633E8
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 12:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfGIKGQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jul 2019 06:06:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbfGIKGQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jul 2019 06:06:16 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69A2mEV105566
        for <kvm-ppc@vger.kernel.org>; Tue, 9 Jul 2019 06:06:16 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmrd6s92h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jul 2019 06:06:15 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 9 Jul 2019 11:06:13 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 11:06:10 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69A5uIN39190860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 10:05:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3D89A4054;
        Tue,  9 Jul 2019 10:06:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2346BA405F;
        Tue,  9 Jul 2019 10:06:07 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.81.51])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  9 Jul 2019 10:06:06 +0000 (GMT)
Date:   Tue, 9 Jul 2019 15:36:04 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [RFC PATCH v4 6/6] kvmppc: Support reset of secure guest
Reply-To: bharata@linux.ibm.com
References: <20190528064933.23119-1-bharata@linux.ibm.com>
 <20190528064933.23119-7-bharata@linux.ibm.com>
 <20190617040632.jiq73ogxqyccvfjl@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617040632.jiq73ogxqyccvfjl@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-TM-AS-GCONF: 00
x-cbid: 19070910-0028-0000-0000-000003824118
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070910-0029-0000-0000-000024424CDC
Message-Id: <20190709100604.GD27933@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090122
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jun 17, 2019 at 02:06:32PM +1000, Paul Mackerras wrote:
> On Tue, May 28, 2019 at 12:19:33PM +0530, Bharata B Rao wrote:
> > Add support for reset of secure guest via a new ioctl KVM_PPC_SVM_OFF.
> > This ioctl will be issued by QEMU during reset and in this ioctl,
> > we ask UV to terminate the guest via UV_SVM_TERMINATE ucall,
> > reinitialize guest's partitioned scoped page tables and release all
> > HMM pages of the secure guest.
> > 
> > After these steps, guest is ready to issue UV_ESM call once again
> > to switch to secure mode.
> 
> Since you are adding a new KVM ioctl, you need to add a description of
> it to Documentation/virtual/kvm/api.txt.

Adding in the next version.

Regards,
Bharata.

