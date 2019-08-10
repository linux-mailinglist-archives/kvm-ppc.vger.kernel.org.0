Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEBB88BBE
	for <lists+kvm-ppc@lfdr.de>; Sat, 10 Aug 2019 16:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfHJOVT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 10 Aug 2019 10:21:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbfHJOVT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 10 Aug 2019 10:21:19 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7AEGdWS081272
        for <kvm-ppc@vger.kernel.org>; Sat, 10 Aug 2019 10:21:17 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u9swvfxn3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 10 Aug 2019 10:21:17 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Sat, 10 Aug 2019 15:21:15 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 10 Aug 2019 15:21:12 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7AELAKR49283154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Aug 2019 14:21:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F220AE055;
        Sat, 10 Aug 2019 14:21:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D63C1AE045;
        Sat, 10 Aug 2019 14:21:08 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.47.133])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 10 Aug 2019 14:21:08 +0000 (GMT)
Date:   Sat, 10 Aug 2019 19:51:06 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v6 1/7] kvmppc: Driver to manage pages of secure guest
Reply-To: bharata@linux.ibm.com
References: <20190809084108.30343-1-bharata@linux.ibm.com>
 <20190809084108.30343-2-bharata@linux.ibm.com>
 <20190810105819.GA26030@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190810105819.GA26030@lst.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-TM-AS-GCONF: 00
x-cbid: 19081014-4275-0000-0000-000003577F07
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081014-4276-0000-0000-0000386988C0
Message-Id: <20190810142106.GB28418@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-10_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908100159
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Aug 10, 2019 at 12:58:19PM +0200, Christoph Hellwig wrote:
> 
> > +int kvmppc_devm_init(void)
> > +{
> > +	int ret = 0;
> > +	unsigned long size;
> > +	struct resource *res;
> > +	void *addr;
> > +
> > +	size = kvmppc_get_secmem_size();
> > +	if (!size) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	ret = alloc_chrdev_region(&kvmppc_devm.devt, 0, 1,
> > +				"kvmppc-devm");
> > +	if (ret)
> > +		goto out;
> > +
> > +	dev_set_name(&kvmppc_devm.dev, "kvmppc_devm_device%d", 0);
> > +	kvmppc_devm.dev.release = kvmppc_devm_release;
> > +	device_initialize(&kvmppc_devm.dev);
> > +	res = devm_request_free_mem_region(&kvmppc_devm.dev,
> > +		&iomem_resource, size);
> > +	if (IS_ERR(res)) {
> > +		ret = PTR_ERR(res);
> > +		goto out_unregister;
> > +	}
> > +
> > +	kvmppc_devm.pagemap.type = MEMORY_DEVICE_PRIVATE;
> > +	kvmppc_devm.pagemap.res = *res;
> > +	kvmppc_devm.pagemap.ops = &kvmppc_devm_ops;
> > +	addr = devm_memremap_pages(&kvmppc_devm.dev, &kvmppc_devm.pagemap);
> > +	if (IS_ERR(addr)) {
> > +		ret = PTR_ERR(addr);
> > +		goto out_unregister;
> > +	}
> 
> It seems a little silly to allocate a struct device just so that we can
> pass it to devm_request_free_mem_region and devm_memremap_pages.  I think
> we should just create non-dev_ versions of those as well.

There is no reason for us to create a device really. If non-dev versions
of the above two routines are present, I can switch.

I will take care of the rest of your comments. Thanks for the review.

Regards,
Bharata.

