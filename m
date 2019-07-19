Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E3D6E259
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Jul 2019 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfGSIOp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Jul 2019 04:14:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbfGSIOp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Jul 2019 04:14:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6J8DMIM129672
        for <kvm-ppc@vger.kernel.org>; Fri, 19 Jul 2019 04:14:44 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tu8ggbhw9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 19 Jul 2019 04:14:44 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Fri, 19 Jul 2019 09:14:42 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 19 Jul 2019 09:14:38 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6J8EbSS43712524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 08:14:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0178AAE051;
        Fri, 19 Jul 2019 08:14:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9FABAE056;
        Fri, 19 Jul 2019 08:14:34 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.65])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Jul 2019 08:14:34 +0000 (GMT)
Date:   Fri, 19 Jul 2019 13:44:32 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>,
        linux-mm@kvack.org, jglisse@redhat.com,
        janani <janani@linux.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        paulus@au1.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 1/7] kvmppc: HMM backend driver to manage pages of
 secure guest
Reply-To: bharata@linux.ibm.com
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-2-bharata@linux.ibm.com>
 <29e536f225036d2a93e653c56a961fcb@linux.vnet.ibm.com>
 <20190710134734.GB2873@ziepe.ca>
 <20190711050848.GB12321@in.ibm.com>
 <20190719064641.GA29238@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719064641.GA29238@infradead.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-TM-AS-GCONF: 00
x-cbid: 19071908-0012-0000-0000-00000334517F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071908-0013-0000-0000-0000216DD618
Message-Id: <20190719081432.GA4077@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=915 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190094
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 18, 2019 at 11:46:41PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 11, 2019 at 10:38:48AM +0530, Bharata B Rao wrote:
> > Hmmm... I still find it in upstream, guess it will be removed soon?
> > 
> > I find the below commit in mmotm.
> 
> Please take a look at the latest hmm code in mainline, there have
> also been other significant changes as well.

Yes, my next version of this patchset will be based on those recent
HMM related changes.

Regards,
Bharata.

