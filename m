Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48751187944
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 06:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgCQFbe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 01:31:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725468AbgCQFbe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Mar 2020 01:31:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H5Ut6W074471
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Mar 2020 01:31:32 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yrr6tq3j1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Mar 2020 01:31:32 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 17 Mar 2020 05:31:30 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 17 Mar 2020 05:31:26 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02H5VPA557016414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 05:31:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78A77A4059;
        Tue, 17 Mar 2020 05:31:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A39BA4051;
        Tue, 17 Mar 2020 05:31:23 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.32.136])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Mar 2020 05:31:23 +0000 (GMT)
Date:   Tue, 17 Mar 2020 11:01:21 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: ensure device private pages have an owner v2
Reply-To: bharata@linux.ibm.com
References: <20200316193216.920734-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316193216.920734-1-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 20031705-4275-0000-0000-000003AD96C0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031705-4276-0000-0000-000038C2BE9E
Message-Id: <20200317053121.GA22538@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_11:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=943 adultscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170022
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 08:32:12PM +0100, Christoph Hellwig wrote:
> When acting on device private mappings a driver needs to know if the
> device (or other entity in case of kvmppc) actually owns this private
> mapping.  This series adds an owner field and converts the migrate_vma
> code over to check it.  I looked into doing the same for
> hmm_range_fault, but as far as I can tell that code has never been
> wired up to actually work for device private memory, so instead of
> trying to fix some unused code the second patch just remove the code.
> We can add it back once we have a working and fully tested code, and
> then should pass the expected owner in the hmm_range structure.

Boot-tested a pseries secure guest with this change (1/4 and 2/4 only)

So Tested-by: Bharata B Rao <bharata@linux.ibm.com> for the above
two patches.

Regards,
Bharata.

