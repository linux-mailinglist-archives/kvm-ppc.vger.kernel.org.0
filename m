Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1B286DF3
	for <lists+kvm-ppc@lfdr.de>; Thu,  8 Oct 2020 07:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgJHFRg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 8 Oct 2020 01:17:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728132AbgJHFRg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 8 Oct 2020 01:17:36 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09857bs2050696;
        Thu, 8 Oct 2020 01:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=NawSu7taze30v9JrwKG21rHX7O3UERKk5e7HU0ddEqs=;
 b=keRb4EW6iNfG8XIWZcHr5FR9aqZ9cYqEelpjfvJUKPKkHG/l6grDgpdRvM4PC0QC8rzY
 OSiMsKXunVXH2yxNgXg5TjlogjaSYE+/vBNdCzrdkTOODQEZMm+vDE1fJ4szTnF9onov
 e72VNGNSTeDrPGl+t2bB/8ZQYI3kQb0yF1pyCWu49/X4v4yI9oAqLija7UbaXVZVh382
 fv91tqGNcJsjhQ4oCUwN2rsLN7B/5FMCDCPjym3UabzVkGlnUh63H1QLQenB4B25rgeT
 le6oa9TZ7TA8339yOgPBGtw5JFlecod00pR0YY7rVUze8ao0cKla7GhLFxQ8u6uSFkRJ +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341unssc4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Oct 2020 01:17:15 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0985HE6u083044;
        Thu, 8 Oct 2020 01:17:14 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341unssc3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Oct 2020 01:17:14 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09858HL1008864;
        Thu, 8 Oct 2020 05:17:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 33xgx8ak2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Oct 2020 05:17:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0985H98h30540256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Oct 2020 05:17:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB8684C040;
        Thu,  8 Oct 2020 05:17:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D3244C050;
        Thu,  8 Oct 2020 05:17:05 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.85.204.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  8 Oct 2020 05:17:05 +0000 (GMT)
Date:   Wed, 7 Oct 2020 22:17:02 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v3 2/2] mm: remove extra ZONE_DEVICE struct page
 refcount
Message-ID: <20201008051702.GA4773@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20201001181715.17416-1-rcampbell@nvidia.com>
 <20201001181715.17416-3-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001181715.17416-3-rcampbell@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_01:2020-10-07,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 clxscore=1011 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080035
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 01, 2020 at 11:17:15AM -0700, Ralph Campbell wrote:
> ZONE_DEVICE struct pages have an extra reference count that complicates the
> code for put_page() and several places in the kernel that need to check the
> reference count to see that a page is not being used (gup, compaction,
> migration, etc.). Clean up the code so the reference count doesn't need to
> be treated specially for ZONE_DEVICE.


I was hoping this patch would resolve a page-reference issue that we run
into at random times while migrating a page to a device page backed by
secure-memory.

Unfortunately I continue to see the problem. There is a reference
held on that page, which fails the migration.

FYI
RP
