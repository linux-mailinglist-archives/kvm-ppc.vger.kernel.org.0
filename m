Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C93A3727BA
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 May 2021 11:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhEDJER (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 May 2021 05:04:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230025AbhEDJEQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 4 May 2021 05:04:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1448j0js066751;
        Tue, 4 May 2021 05:03:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hhDEWmzdghAGZtZeuFoepYTZTUQE5WKYZBIlzMAcUTA=;
 b=d7+vOBz1ri3+XgqQR42vv3qJScc1w4ZbNER4dpNQQ6ZglnvFfLQkKXqwrFTa3us9On2c
 pEE98fAtiWC3LY/+ZFZSkiJjRc4CUdOvfCEzlUqZQz8KOhoD08Yj4EWJMs2/9W96TvpW
 iLWMTYUNoOP2nnAdyrLgMbT2MY0MqKjTov6/yGXy+/RHjwmwqSor4HWjyZvD+Z1G1qhE
 dYGuVhF88ksA0/b/b2Kv2hzWj93ZhYnHj0wJb+k1xkOa5LNN4NG1SZhATHlnl7VFeSru
 Dr0VjU6Ap6yKVuAd1P1vO6t4ZESd7TAO+JrSV5B9BgoCQRACMArzuoH8KJ+H9VV6G/kG LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38b31g0e92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 05:03:01 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1448j9SN067112;
        Tue, 4 May 2021 05:03:00 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38b31g0e85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 05:03:00 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1448xmtx021764;
        Tue, 4 May 2021 09:02:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 388xm8gkv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 09:02:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14492ttr32440578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 May 2021 09:02:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1ECE4204D;
        Tue,  4 May 2021 09:02:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20EEC42041;
        Tue,  4 May 2021 09:02:51 +0000 (GMT)
Received: from [9.199.50.4] (unknown [9.199.50.4])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 May 2021 09:02:50 +0000 (GMT)
Subject: Re: [PATCH v4 0/3] nvdimm: Enable sync-dax property for nvdimm
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eric Blake <eblake@redhat.com>, qemu-arm@nongnu.org,
        richard.henderson@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>,
        shameerali.kolothum.thodi@huawei.com, kwangwoo.lee@sk.com,
        Markus Armbruster <armbru@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        kvm-ppc@vger.kernel.org, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
 <CAPcyv4gwkyDBG7EZOth-kcZR8Fb+RgGXY=Y9vbuHXAz3PAnLVw@mail.gmail.com>
 <bca3512d-5437-e8e6-68ae-0c9b887115f9@linux.ibm.com>
 <CAPcyv4hAOC89JOXr-ZCps=n8gEKD5W0jmGU1Enfo8ECVMf3veQ@mail.gmail.com>
 <d21fcac6-6a54-35fd-3088-6c56b85fbf25@linux.ibm.com>
 <CAM9Jb+g8bKF0Z7za4sZpc2tZ01Sp4c4FEaV65He8w1+QOL3_yw@mail.gmail.com>
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <023e584a-6110-4d17-7fec-ca715226f869@linux.ibm.com>
Date:   Tue, 4 May 2021 14:32:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAM9Jb+g8bKF0Z7za4sZpc2tZ01Sp4c4FEaV65He8w1+QOL3_yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WyHOa4EB6zQCHAcN_OgqWSEtUI8wMYIe
X-Proofpoint-ORIG-GUID: KmKW0vgbGyeSeoxKHoyeFcbJvHRk7H6a
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_05:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040062
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 5/4/21 11:13 AM, Pankaj Gupta wrote:
....

>>
>> What this patch series did was to express that property via a device
>> tree node and guest driver enables a hypercall based flush mechanism to
>> ensure persistence.
> 
> Would VIRTIO (entirely asynchronous, no trap at host side) based
> mechanism is better
> than hyper-call based? Registering memory can be done any way. We
> implemented virtio-pmem
> flush mechanisms with below considerations:
> 
> - Proper semantic for guest flush requests.
> - Efficient mechanism for performance pov.
> 

sure, virio-pmem can be used as an alternative.

> I am just asking myself if we have platform agnostic mechanism already
> there, maybe
> we can extend it to suit our needs? Maybe I am missing some points here.
> 

What is being attempted in this series is to indicate to the guest OS 
that the backing device/file used for emulated nvdimm device cannot 
guarantee the persistence via cpu cache flush instructions.


>>>> On PPC, the default is "sync-dax=writeback" - so the ND_REGION_ASYNC
>>>>
>>>> is set for the region and the guest makes hcalls to issue fsync on the host.
>>>>
>>>>
>>>> Are you suggesting me to keep it "unsafe" as default for all architectures
>>>>
>>>> including PPC and a user can set it to "writeback" if desired.
>>>
>>> No, I am suggesting that "sync-dax" is insufficient to convey this
>>> property. This behavior warrants its own device type, not an ambiguous
>>> property of the memory-backend-file with implicit architecture
>>> assumptions attached.
>>>
>>
>> Why is it insufficient?  Is it because other architectures don't have an
>> ability express this detail to guest OS? Isn't that an arch limitations?

-aneesh
