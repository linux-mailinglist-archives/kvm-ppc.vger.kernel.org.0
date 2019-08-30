Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE79A3577
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Aug 2019 13:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfH3LNo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Aug 2019 07:13:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbfH3LNo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 30 Aug 2019 07:13:44 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UBC9uF081488
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Aug 2019 07:13:43 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq25whd6j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Aug 2019 07:13:43 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Fri, 30 Aug 2019 12:13:40 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 30 Aug 2019 12:13:38 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UBDaHf59965478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 11:13:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BDB9A405F;
        Fri, 30 Aug 2019 11:13:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E47B3A405C;
        Fri, 30 Aug 2019 11:13:34 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.81.70])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 30 Aug 2019 11:13:34 +0000 (GMT)
Date:   Fri, 30 Aug 2019 16:43:32 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v7 1/7] kvmppc: Driver to manage pages of secure guest
Reply-To: bharata@linux.ibm.com
References: <20190822102620.21897-1-bharata@linux.ibm.com>
 <20190822102620.21897-2-bharata@linux.ibm.com>
 <20190829030219.GA17497@us.ibm.com>
 <20190829065642.GA31913@in.ibm.com>
 <20190829193911.GA26729@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829193911.GA26729@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19083011-0020-0000-0000-000003659D50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19083011-0021-0000-0000-000021BAF9A8
Message-Id: <20190830111332.GE31913@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=953 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300122
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 29, 2019 at 12:39:11PM -0700, Sukadev Bhattiprolu wrote:
> Bharata B Rao [bharata@linux.ibm.com] wrote:
> > On Wed, Aug 28, 2019 at 08:02:19PM -0700, Sukadev Bhattiprolu wrote:
> Where do we serialize two threads attempting to H_SVM_PAGE_IN the same gfn
> at the same time? Or one thread issuing a H_SVM_PAGE_IN and another a
> H_SVM_PAGE_OUT for the same page?

I am not not serializing page-in/out calls on same gfn, I thought you take
care of that in UV, guess UV doesn't yet.

I can probably use rmap_lock() and serialize such calls in HV if UV can't
prevent such calls easily.

> > > > +
> > > > +	if (!trylock_page(dpage))
> > > > +		goto out_clear;
> > > > +
> > > > +	*rmap = devm_pfn | KVMPPC_RMAP_DEVM_PFN;
> > > > +	pvt = kzalloc(sizeof(*pvt), GFP_ATOMIC);
> > > > +	if (!pvt)
> > > > +		goto out_unlock;
> 
> If we fail to alloc, we don't clear the KVMPPC_RMAP_DEVM_PFN?

Right, I will move the assignment to *rmap to after kzalloc.

> 
> Also, when/where do we clear this flag on an uv-page-out?
> kvmppc_devm_drop_pages() drops the flag on a local variable but not
> in the rmap? If we don't clear the flag on page-out, would the
> subsequent H_SVM_PAGE_IN of this page fail?

It gets cleared in kvmppc_devm_page_free().

> 
> Ok. Nit. thought we can drop the "_fault" in the function name but would
> collide the other "alloc_and_copy" function used during H_SVM_PAGE_IN.
> If the two alloc_and_copy functions are symmetric, maybe they could
> have "page_in" and "page_out" in the (already long) names.

Christoph also suggested to reorganize these two calls. Will take care.

Regards,
Bharata.

