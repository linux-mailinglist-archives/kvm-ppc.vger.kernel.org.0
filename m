Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5EE2CA348
	for <lists+kvm-ppc@lfdr.de>; Tue,  1 Dec 2020 13:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgLAM6e (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 1 Dec 2020 07:58:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbgLAM6e (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 1 Dec 2020 07:58:34 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1CY7Oj017576;
        Tue, 1 Dec 2020 07:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sbV3uab1LjOlzWt1Az4R0UDoFrfh46cjnex6y69sD7w=;
 b=i/8KDsQQnm0KOdZQuXbZZbimKCSRzkNG2axEvDJ+Nc7rkUZYIzO7a5b2ZxnRW/P2ECjd
 WzGiv0yj+EXVoKDa5jCJ4KajqvBDTdtG0yFbe6w91/MojQ/Yn/vsH9ciCwarCyI6GWqv
 060qEsJ6dwotH43yIq3UIPr5x5NL3xtlz+yYkhxyotOG9Zdf9z0we0bTVeJd+kApynyw
 G/mZ10sW297JZBUs+W0B7uSBahJYesp1kemPGVlc3RG+CU23hdfDQzYGBnkPQ0W/O0TK
 yBnrOBXVO5PfBldBOoGvxoXARdCFu4dJQ8j2kVDSjdXbgIeGQn9YtHhHGksqC0aX03vj tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355jwuxdrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 07:57:45 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B1CYD6w019438;
        Tue, 1 Dec 2020 07:57:45 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355jwuxdqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 07:57:45 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1CruRk013037;
        Tue, 1 Dec 2020 12:57:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 353e683501-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 12:57:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1Cvem28782404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 12:57:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 716EA4C04E;
        Tue,  1 Dec 2020 12:57:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF95F4C04A;
        Tue,  1 Dec 2020 12:57:37 +0000 (GMT)
Received: from [9.85.97.131] (unknown [9.85.97.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 12:57:37 +0000 (GMT)
Subject: Re: [RFC PATCH] powerpc/papr_scm: Implement scm async flush
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc:     ellerman@au1.ibm.com, linux-nvdimm <linux-nvdimm@lists.01.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
References: <160682501436.2579014.14501834468510806255.stgit@lep8c.aus.stglabs.ibm.com>
 <CAM9Jb+iPV470063QYq145znYW8CmqjNgdL=q6=3JXUJJt+z5gw@mail.gmail.com>
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <20035bbc-a1e0-82fd-105d-999e1afff029@linux.ibm.com>
Date:   Tue, 1 Dec 2020 18:27:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAM9Jb+iPV470063QYq145znYW8CmqjNgdL=q6=3JXUJJt+z5gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_04:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=939 spamscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010081
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 12/1/20 6:17 PM, Pankaj Gupta wrote:
>> Tha patch implements SCM async-flush hcall and sets the
>> ND_REGION_ASYNC capability when the platform device tree
>> has "ibm,async-flush-required" set.
> 
> So, you are reusing the existing ND_REGION_ASYNC flag for the
> hypercall based async flush with device tree discovery?
> 
> Out of curiosity, does virtio based flush work in ppc? Was just thinking
> if we can reuse virtio based flush present in virtio-pmem? Or anything
> else we are trying to achieve here?
> 


Not with PAPR based pmem driver papr_scm.ko. The devices there are 
considered platform device and we use hypercalls to configure the 
device. On similar fashion we are now using hypercall to flush the host 
based caches.

-aneesh
