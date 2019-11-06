Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2285CF1132
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 09:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbfKFIg5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 03:36:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730088AbfKFIg5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 6 Nov 2019 03:36:57 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA68RrtO082478
        for <kvm-ppc@vger.kernel.org>; Wed, 6 Nov 2019 03:36:54 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w3tpgg7jb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 06 Nov 2019 03:36:54 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 6 Nov 2019 08:36:52 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 6 Nov 2019 08:36:50 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA68ammj47382788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 08:36:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ADDA11C070;
        Wed,  6 Nov 2019 08:36:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EE8711C052;
        Wed,  6 Nov 2019 08:36:46 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.101])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 Nov 2019 08:36:46 +0000 (GMT)
Date:   Wed, 6 Nov 2019 14:06:44 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 4/8] KVM: PPC: Radix changes for secure guest
Reply-To: bharata@linux.ibm.com
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-5-bharata@linux.ibm.com>
 <20191106055823.GE12069@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106055823.GE12069@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19110608-0012-0000-0000-0000036125D8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110608-0013-0000-0000-0000219C81C5
Message-Id: <20191106083644.GE21634@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=990 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911060088
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Nov 06, 2019 at 04:58:23PM +1100, Paul Mackerras wrote:
> On Mon, Nov 04, 2019 at 09:47:56AM +0530, Bharata B Rao wrote:
> > - After the guest becomes secure, when we handle a page fault of a page
> >   belonging to SVM in HV, send that page to UV via UV_PAGE_IN.
> > - Whenever a page is unmapped on the HV side, inform UV via UV_PAGE_INVAL.
> > - Ensure all those routines that walk the secondary page tables of
> >   the guest don't do so in case of secure VM. For secure guest, the
> >   active secondary page tables are in secure memory and the secondary
> >   page tables in HV are freed when guest becomes secure.
> 
> Why do we free the page tables?  Just to save a little memory?  It
> feels like it would make things more fragile.

I guess we could just leave the page tables around and they would get
populated again if and when the guest is reset (i,e., when it goes back
to non-secure mode)

However it appeared cleaner to cleanup the page tables given that aren't
in user any longer.
> 
> Also, I don't see where the freeing gets done in this patch.

There isn't a very good reason for freeing code to be not part of this patch.
I just put that in reset patch (6/8) where there is code for reinitializing
page tables again.

Regards,
Bharata.

